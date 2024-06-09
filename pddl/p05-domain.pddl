(define (domain p05-domain)

;remove requirements that are not needed
(:requirements 
    :strips 
    :typing
    :durative-actions
)

(:types 
    robot - locatable 
    location
)

(:predicates 
    (free ?r - robot)   ; robot is free
    (at ?obj - locatable ?l - location)  ; locatable e is at location l
    (connected ?l1 ?l2 - location)    ; location l1 is connected to location l2
)

(:durative-action move
    :parameters (?r - robot ?l1 - location ?l2 - location)
    :duration (= ?duration 4)
    :condition (and 
        (at start (and
            (free ?r)
            (at ?r ?l1)
        ))
        (over all (and 
            (connected ?l1 ?l2)
        ))
    )
    :effect (and 
        (at start (and 
            (not (free ?r))
            (not (at ?r ?l1))
        ))
        (at end (and 
            (at ?r ?l2)
            (free ?r)
        ))
    )
)


)