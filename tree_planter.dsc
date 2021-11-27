tree_planter:
    type: world
    debug: false
    events:
        after *_sapling spawns:
        - flag <context.entity> sapling_anger:0
        - wait 1s
        - while <context.entity.is_spawned>:
            - if <server.recent_tps.get[1]> < 18:
                - stop
            - define plant_location <context.entity.location>
            - define random_height <util.random.decimal[0.5].to[2.0]>
            - define wait_time <util.random.decimal[1.0].to[1.45]>
            - define anger_particles <context.entity.flag[sapling_anger].mul[<util.random.int[1].to[3]>]>
            - define original_sapling_anger <context.entity.flag[sapling_anger]>
            - if <[anger_particles]> > 10:
                - define anger_particles 10
            - else if <[anger_particles]> < 0:
                - define anger_particles 0
            - if <context.entity.location.down.material.name> in *dirt|grass_block|moss_block|podzol && <context.entity.location.material.name> in air|grass|dead_bush:
                - define landing <[plant_location].random_offset[3,0,3]>
                - modifyblock <context.entity.location> <context.item.material>
                - playeffect villager_happy at:<[plant_location]> quantity:<[original_sapling_anger].mul[5].min[50].max[5]> offset:0.5,0.5,0.5
                - playsound <[plant_location]> sound:BLOCK_GRASS_PLACE sound_category:master volume:0.2
                - remove <context.entity>
                - if <context.item.quantity> > 1:
                    - drop <context.item.with[quantity=<context.item.quantity.sub[1]>]> <[plant_location]> save:dropped_item
                    - shoot <entry[dropped_item].dropped_entity> origin:<entry[dropped_item].dropped_entity.location> destination:<[landing]> height:<[random_height]>
                - stop
            - else if <context.entity.is_on_ground> || <context.entity.location.material.name> == water:
                - define landing <[plant_location].random_offset[<[original_sapling_anger].mul[1.2].max[3].min[6]>,0,<[original_sapling_anger].mul[1.2].max[3].min[6]>]>
                - define random_height <util.random.decimal[0.5].to[<[original_sapling_anger].mul[0.8].min[3].max[0.5]>]>
                - if <[original_sapling_anger]> < 30:
                    - playsound <[plant_location]> sound:item_dye_use volume:<[original_sapling_anger].div[10].max[0.1]>
                    - playeffect smoke at:<[plant_location]> quantity:<[original_sapling_anger].mul[4].min[30]> offset:0.3,0,0.3
                - else:
                    - playsound <[plant_location]> sound:entity_silverfish_hurt volume:0<[original_sapling_anger].div[20].min[1.0]>
                    - playeffect flame at:<[plant_location]> quantity:<[original_sapling_anger].mul[4].min[30]> offset:0.3,0,0.3
                - if <[original_sapling_anger]> < 50:
                    - playeffect villager_angry at:<[plant_location].add[0,0.3,0]> quantity:<[anger_particles]> offset:0.1,0.05,0.1
                    - shoot <context.entity> origin:<context.entity.location> destination:<[landing]> height:<[random_height]>
                    - flag <context.entity> sapling_anger:+:1
                - else:
                    - playeffect flame at:<[plant_location]> quantity:50 offset:0.2,0.2,0.2
                    - remove <context.entity>
                    - if <[plant_location].material.name> == air:
                        - modifyblock <[plant_location]> fire
                    - playsound <[plant_location]> sound:entity_silverfish_death volume:0.8
            - wait <[wait_time]>s
        after *_sapling merges:
        - define amount <context.target.item.quantity.add[<context.entity.item.quantity>]>
        - define location <context.target.location>
        - remove <context.target>
        - drop <context.item.with[quantity=<[amount]>]> <[location]>