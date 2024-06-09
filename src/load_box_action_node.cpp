#include <memory>
#include <algorithm>

#include "plansys2_executor/ActionExecutorClient.hpp"

#include "rclcpp/rclcpp.hpp"
#include "rclcpp_action/rclcpp_action.hpp"

using namespace std::chrono_literals;

class LoadBoxAction : public plansys2::ActionExecutorClient
{
public:
  LoadBoxAction()
  : plansys2::ActionExecutorClient("loadbox", 200ms)
  {
    progress_ = 0.0;
  }

private:
    void do_work()
    {
        if (progress_ < 1.0) {
        progress_ += 0.02;
        send_feedback(progress_, "LoadBox running");
        } else {
        finish(true, 1.0, "LoadBox completed");
    
        progress_ = 0.0;
        std::cout << std::endl;
        }
    
        std::cout << "\r\e[K" << std::flush;
        std::cout << "Loading box ... [" << std::min(100.0, progress_ * 100.0) << "%]  " <<
        std::flush;
    }
    
    float progress_;
};

int main(int argc, char ** argv)
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<LoadBoxAction>();

    node->set_parameter(rclcpp::Parameter("action_name", "loadbox"));
    node->trigger_transition(lifecycle_msgs::msg::Transition::TRANSITION_CONFIGURE);

    rclcpp::spin(node->get_node_base_interface());

    rclcpp::shutdown();

    return 0;
}