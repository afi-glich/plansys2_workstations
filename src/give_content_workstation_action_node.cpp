#include <memory>
#include <algorithm>

#include "plansys2_executor/ActionExecutorClient.hpp"

#include "rclcpp/rclcpp.hpp"
#include "rclcpp_action/rclcpp_action.hpp"

using namespace std::chrono_literals;

class GiveContentWorkstationAction : public plansys2::ActionExecutorClient
{
public:
  GiveContentWorkstationAction()
  : plansys2::ActionExecutorClient("giveworkstation", 400ms)
  {
    progress_ = 0.0;
  }

private:
    void do_work()
    {
        if (progress_ < 1.0) {
        progress_ += 0.02;
        send_feedback(progress_, "GiveContentWorkstation running");
        } else {
        finish(true, 1.0, "GiveContentWorkstation completed");
    
        progress_ = 0.0;
        std::cout << std::endl;
        }
    
        std::cout << "\r\e[K" << std::flush;
        std::cout << "Giving content workstation ... [" << std::min(100.0, progress_ * 100.0) << "%]  " <<
        std::flush;
    }
    
    float progress_;
};

int main(int argc, char ** argv)
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<GiveContentWorkstationAction>();

    node->set_parameter(rclcpp::Parameter("action_name", "giveworkstation"));
    node->trigger_transition(lifecycle_msgs::msg::Transition::TRANSITION_CONFIGURE);

    rclcpp::spin(node->get_node_base_interface());

    rclcpp::shutdown();

    return 0;
}