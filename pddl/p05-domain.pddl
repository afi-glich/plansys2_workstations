(define (domain p05-domain)

; TODO:
; 1) the check the capacity of the carrier. if not with numeric fluents then with predicates
; 2) the addition of different type of content: understand how hierarchy can work
; 3) adding predicates to assign directly a different type of content to the workstation

;remove requirements that are not needed
(:requirements 
    :strips 
    :typing
    :durative-actions
)

(:types 
    ; all the types described as locatable can be positionsed in a location
    robot - locatable 
    box - locatable
    workstation - locatable
    carrier - locatable
    content - locatable
    location
    capacity_value
)

(:predicates 
    (free ?r - robot)   ; robot is free
    (at ?obj - locatable ?l - location)  ; locatable e is at location l
    (filled ?b - box ?c - content)  ; content c is in box b
    (empty ?b - box)  ; box b is empty
    (has_workstation ?c - content ?w - workstation)    ; object o is at workstation w
    (connected ?l1 ?l2 - location)    ; location l1 is connected to location l2
    (has_carrier ?k - carrier ?r - robot)    ; carrier k is with robot r
    (on ?b - box ?c - carrier)    ; box b is on carrier 
    (capacity ?k - carrier ?n - capacity_value)    ; carrier k has a capacity of n
    (next_load ?n1 ?n2 - capacity_value)    ; next load of carrier
)

;define actions here
(:durative-action loadbox
    :parameters (?r - robot ?b - box ?l - location ?k - carrier ?n2 ?n1 - capacity_value)
    :duration (= ?duration 3)
    :condition (and 
        (at start (and 
            (free ?r) 
            (at ?b ?l)
            (capacity ?k ?n2)
            (next_load ?n1 ?n2)
        ))
        (over all (and 
            (at ?r ?l)
            (has_carrier ?k ?r)
        ))
    )
    :effect (and 
        (at start (and
            (not (free ?r))
            (not (at ?b ?l))
        ))
        (at end (and 
            (on ?b ?k)
            (free ?r)
            (not (capacity ?k ?n2))
            (capacity ?k ?n1)
        ))
    )
)

(:durative-action fillbox
    :parameters (?r - robot ?b - box ?c - content ?l - location)
    :duration (= ?duration 3)
    :condition (and 
        (at start (and
            (free ?r)
            (at ?c ?l)
            (empty ?b)
        ))
        (over all (and 
            (at ?r ?l)
            (at ?b ?l)
        ))
    )
    :effect (and 
        (at start (and 
            (not (free ?r))
            (not (at ?c ?l))
        ))
        (at end (and
            (filled ?b ?c)
            (not (empty ?b))
            (free ?r) 
        ))
    )
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

(:durative-action unloadbox
    :parameters (?r - robot ?b - box ?k - carrier ?l - location ?n1 ?n2 - capacity_value)
    :duration (= ?duration 3)
    :condition (and 
        (at start (and 
            (free ?r)
            (on ?b ?k)
            (next_load ?n1 ?n2)
            (capacity ?k ?n1)
        ))
        (over all (and 
            (at ?r ?l)
            (has_carrier ?k ?r)
        ))
    )
    :effect (and 
        (at start (and 
            (not (free ?r))
            (not (on ?b ?k))
        ))
        (at end (and
            (at ?b ?l)
            (free ?r)
            (not (capacity ?k ?n1))
            (capacity ?k ?n2)
        ))
    )
)

(:durative-action givecontentworkstation
    :parameters (?r - robot ?b - box ?c - content ?l - location ?w - workstation)
    :duration (= ?duration 2)
    :condition (and 
        (at start (and 
            (free ?r)
            (filled ?b ?c)
        ))
        (over all (and 
            (at ?r ?l)
            (at ?w ?l)
            (at ?b ?l)
        ))
    )
    :effect (and 
        (at start (and 
            (not (free ?r))
            (not (filled ?b ?c))
        ))
        (at end (and
            (has_workstation ?c ?w)
            (free ?r)
            (empty ?b)
        ))
    )
)

)