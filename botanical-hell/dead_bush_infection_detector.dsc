dead_bush_infection_detector:
    type: item
    material: compass
    display name: <&4>Dead Bush Infection Detector
    mechanisms:
        hides: all
    enchantments:
    - unbreaking:1
    recipes:
        1:
            type: shaped
            input:
            - dead_bush|iron_ingot|dead_bush
            - iron_ingot|compass|iron_ingot
            - dead_bush|iron_ingot|dead_bush

dead_bush_infection_detector_use:
    type: world
    debug: false
    events:
        after player right clicks block with:dead_bush_infection_detector location_flagged:dead_bush_infected:
            - actionbar "<&4>This block is infected!"
            - playsound <context.location> sound:block_lever_click sound_category:master pitch:1.4
            - showfake dead_bush <context.location> d:1.5s players:<server.online_players>


