manipulation_detector:
    type: world
    debug: false
    events:
        after player breaks block:
            - flag <context.location> player_manipulated:true
        after player places block:
            - flag <context.location> player_manipulated:true