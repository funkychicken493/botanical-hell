dead_bush_planter:
    type: world
    debug: false
    events:
        after dead_bush spawns:
        - flag <context.entity> bush_despawn_value:0
        - wait 1s
        - while <context.entity.is_spawned>:
            - if <server.recent_tps.get[1]> < 18:
                - stop
            - define plant_location <context.entity.location>
            - define random_height <util.random.decimal[0.5].to[2.0]>
            - define wait_time <util.random.decimal[1.0].to[1.45]>
            - define despawn_value <context.entity.flag[bush_despawn_value]>
            - if <context.entity.location.down.material.name> in *dirt|grass_block|sand|moss_block|podzol|mycelium|netherrack|*_nylium && <context.entity.location.material.name> in air|grass|acacia_sapling|oak_sapling|birch_sapling|dark_oak_sapling|jungle_sapling|spruce_sapling|fern|red_tulip|orange_tulip|white_tulip|pink_tulip|dandelion|poppy|blue_orchid|allium|azure_bluet|oxeye_daisy|cornflower|lily_of_the_valley|*_mushroom|moss_carpet|rose_bush|tall_grass|peony|large_fern|lilac|sunflower:
                - define landing <[plant_location].random_offset[3,0,3]>
                - modifyblock <context.entity.location> <context.item.material>
                - playeffect crit at:<[plant_location]> quantity:15 offset:0.5,0.5,0.5
                - playsound <[plant_location]> sound:BLOCK_GRASS_BREAK sound_category:master volume:0.2
                - remove <context.entity>
                - foreach <[plant_location].find_blocks[grass|*_leaves|*_log].within[5.0]> as:target_block:
                    - if <util.random.int[1].to[10]> == 1:
                        - flag <[target_block]> dead_bush_infected:true
                - drop <context.item.with[quantity=<context.item.quantity.add[<util.random.int[-2].to[1]>].max[0].min[64]>]> <[plant_location]> save:dropped_item
                - shoot <entry[dropped_item].dropped_entity> origin:<entry[dropped_item].dropped_entity.location> destination:<[landing]> height:<[random_height]>
                - stop
            - else if <context.entity.is_on_ground> || <context.entity.location.material.name> == water:
                - define landing <[plant_location].random_offset[5]>
                - define random_height <util.random.decimal[0.5].to[3]>
                - playsound <[plant_location]> sound:item_dye_use volume:0.1
                - playeffect smoke at:<[plant_location]> quantity:10 offset:0.15,0,0.15
                - if <[despawn_value]> < 6:
                    - shoot <context.entity> origin:<context.entity.location> destination:<[landing]> height:<[random_height]>
                    - flag <context.entity> bush_despawn_value:+:1
                - else:
                    - playeffect flame at:<[plant_location]> quantity:30 offset:0.2,0.2,0.2
                    - remove <context.entity>
                    - playsound <[plant_location]> sound:entity_generic_death volume:0.4
            - wait <[wait_time]>s
        after dead_bush merges:
        - define amount <context.target.item.quantity.add[<context.entity.item.quantity>]>
        - define location <context.target.location>
        - remove <context.target>
        - drop <context.item.with[quantity=<[amount]>]> <[location]>
        on player breaks *leaves|grass location_flagged:dead_bush_infected with:!crook:
        - determine passively NOTHING
        - drop <item[dead_bush].with[quantity=<util.random.int[1].to[3]>]> <context.location>
        - playeffect smoke <context.location> quantity:20 offset:0.3,0.3,0.3
        - flag <context.location> dead_bush_infected:!
        on player breaks *_log location_flagged:dead_bush_infected:
        - determine passively NOTHING
        - drop <item[stick].with[quantity=<util.random.int[1].to[4]>]> <context.location>
        - playeffect smoke <context.location> quantity:20 offset:0.3,0.3,0.3
        - flag <context.location> dead_bush_infected:!
        on leaves decay location_flagged:dead_bush_infected:
        - drop <item[dead_bush].with[quantity=<util.random.int[1].to[3]>]> <context.location>
        - playeffect smoke <context.location> quantity:20 offset:0.3,0.3,0.3
        - flag <context.location> dead_bush_infected:!