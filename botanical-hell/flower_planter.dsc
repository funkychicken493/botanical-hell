flower_planter:
    type: world
    debug: false
    events:
        after dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley spawns:
        - if <context.item.has_flag[exotic_flower]>:
            - stop
        - flag <context.entity> despawn_value:0
        - wait 3s
        - adjust <context.entity> pickup_delay:1s
        - while <context.entity.is_spawned>:
            - if <server.recent_tps.get[1]> < 18:
                - stop
            - define plant_location <context.entity.location>
            - define random_height <util.random.decimal[3].to[5]>
            - define wait_time <util.random.decimal[0.5].to[1.1]>
            - define original_despawn_value <context.entity.flag[despawn_value]>
            - define landing <[plant_location].random_offset[10,0,10]>
            - if <context.entity.location.down.material.name> in *dirt|grass_block|moss_block|podzol && <context.entity.location.material.name> in air|grass|dead_bush:
                - modifyblock <context.entity.location> <context.item.material>
                - playeffect glow at:<[plant_location]> quantity:30 offset:0.5,0.5,0.5
                - playsound <[plant_location]> sound:BLOCK_GRASS_PLACE sound_category:master volume:0.2
                - remove <context.entity>
                - if <context.item.quantity> > 1:
                    - drop <context.item.with[quantity=<context.item.quantity.sub[1]>]> <[plant_location]> save:dropped_item
                    - if <[plant_location].find.players.within[20].get[1].exists>:
                        - define landing <[plant_location].find.players.within[20].get[1].location.random_offset[3,0,3]>
                    - shoot <entry[dropped_item].dropped_entity> origin:<entry[dropped_item].dropped_entity.location> destination:<[landing]> height:<[random_height]>
                - stop
            - else if <context.entity.is_on_ground> || <context.entity.location.material.name> == water:
                - playsound <[plant_location]> sound:block_amethyst_block_place volume:0.2
                - playeffect smoke at:<[plant_location]> quantity:<[original_despawn_value].mul[4].min[30]> offset:0.3,0,0.3
                - if <[plant_location].find.players.within[20].get[1].exists>:
                    - define landing <[plant_location].find.players.within[20].get[1].location.random_offset[5,0,5]>
                - if <[original_despawn_value]> < 10:
                    - shoot <context.entity> origin:<context.entity.location> destination:<[landing]> height:<[random_height]>
                    - flag <context.entity> despawn_value:+:1
                - else:
                    - playeffect flame at:<[plant_location]> quantity:50 offset:0.2,0.2,0.2
                    - remove <context.entity>
                    - playsound <[plant_location]> sound:entity_generic_death volume:0.8
            - wait <[wait_time]>s
        after dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley merges:
        - define amount <context.target.item.quantity.add[<context.entity.item.quantity>]>
        - define location <context.target.location>
        - remove <context.target>
        - drop <context.item.with[quantity=<[amount]>]> <[location]>
        after bee spawns:
        - while <context.entity.is_spawned>:
            - if <server.recent_tps.get[1]> < 18:
                - stop
            - if !<context.entity.has_flag[bee_cooldown]> && !<context.entity.location.has_flag[flower_cooldown]> && <context.entity.location.material.name> in dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley:
                - drop <context.entity.location.material.item.with[quantity=<util.random.int[3].to[10]>]> <context.entity.location>
                - flag <context.entity.location> flower_cooldown:true expire:1m
                - flag <context.entity> bee_cooldwon:true expire:2m
            - wait 10s