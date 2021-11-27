give_seed_command:
    type: command
    name: giveseed
    description: A command to give you a seed for a custom crop.
    usage: /giveseed seed
    aliases:
    - gs
    - getseed
    permission: denizen.botanical-hell.giveseed
    tab completions:
        1: <script[crop_data].data_key[crops].keys>
        2: <server.online_players.parse[name]>
        3: 64
    script:
    - if !<context.args.get[2].exists>:
        - define target <player>
    - else:
        - define target <player[<context.args.get[2]>]>
    - stop if:<context.args.get[1].exists.not>
    - define crop_id <context.args.get[1]>
    - define name <script[crop_data].data_key[crops.<[crop_id]>.name]>
    - define name_color <script[crop_data].data_key[crops.<[crop_id]>.name_color]>
    - define item <script[crop_data].data_key[crops.<[crop_id]>.item]>
    - define parsed_name <[name_color]><[name]>
    - define built_seed_item <item[<[item]>].with[display=<[parsed_name].parsed>;hides=all;enchantments=<map[unbreaking=1]>].with_flag[crop:true].with_flag[crop_id:<[crop_id]>]>
    - define quantity <context.args.get[3]> if:<context.args.get[3].exists>
    - define quanity 1 if:<context.args.get[3].exists.not>
    - give <[target]> <[built_seed_item]> quantity:<[quantity]>

custom_crops:
    type: world
    debug: false
    events:
        after server start:
            - if !<server.has_flag[crop_blocks]>:
                - flag server crop_blocks:<list[]>
        on player places item:
            - define item_held <context.item_in_hand>
            - stop if:<[item_held].has_flag[crop].not>
            - define crop_id <[item_held].flag[crop_id]>
            - stop if:<script[crop_data].data_key[crops.<[crop_id]>].exists.not>
            - define location <context.location>
            - define type <script[crop_data].data_key[crops.<[crop_id]>.type]>
            - modifyblock <[location]> <[type]>
            - flag <[location]> crop:true
            - flag <[location]> crop_id:<[crop_id]>
            - flag <[location]> crop_age:0
            #note: max age is seven
            - flag server crop_blocks:<server.flag[crop_blocks].include[<[location]>]>
        on block grows:
            - if <context.location.has_flag[crop]>:
                - determine cancelled
        on entity changes block into air:
            - stop if:<context.location.has_flag[crop].not>
            - define crop_id <context.location.flag[crop_id]>]
            - define name <script[crop_data].data_key[crops.<[crop_id]>.name]>
            - define name_color <script[crop_data].data_key[crops.<[crop_id]>.name_color]>
            - define item <script[crop_data].data_key[crops.<[crop_id]>.item]>
            - define parsed_name <[name_color]><[name]>
            - define built_seed_item <item[<[item]>].with[display=<[parsed_name].parsed>;hides=all;enchantments=<map[unbreaking=1]>].with_flag[crop:true].with_flag[crop_id:<[crop_id]>]>
            - drop <[built_seed_item]> quantity:1 at:<context.location>
        on block fades:
            - stop if:<context.location.has_flag[crop].not>
            - define crop_id <context.location.flag[crop_id]>]
            - define name <script[crop_data].data_key[crops.<[crop_id]>.name]>
            - define name_color <script[crop_data].data_key[crops.<[crop_id]>.name_color]>
            - define item <script[crop_data].data_key[crops.<[crop_id]>.item]>
            - define parsed_name <[name_color]><[name]>
            - define built_seed_item <item[<[item]>].with[display=<[parsed_name].parsed>;hides=all;enchantments=<map[unbreaking=1]>].with_flag[crop:true].with_flag[crop_id:<[crop_id]>]>
            - drop <[built_seed_item]> quantity:1 at:<context.location>
        on player breaks block location_flagged:crop:
            - define location <context.location>
            - define crop_id <[location].flag[crop_id]>
            - stop if:<script[crop_data].data_key[crops.<[crop_id]>].exists.not>
            - determine passively NOTHING
            - define name <script[crop_data].data_key[crops.<[crop_id]>.name]>
            - define name_color <script[crop_data].data_key[crops.<[crop_id]>.name_color]>
            - define item <script[crop_data].data_key[crops.<[crop_id]>.item]>
            - define type <script[crop_data].data_key[crops.<[crop_id]>.type]>
            - define growth_chance <script[crop_data].data_key[crops.<[crop_id]>.growth_chance]>
            - define grass_drop_chance <script[crop_data].data_key[crops.<[crop_id]>.grass_drop_chance]>
            - define seed_drop_amount <script[crop_data].data_key[crops.<[crop_id]>.seed_drop_amount]>
            - define drops <script[crop_data].data_key[crops.<[crop_id]>.drops]>
            - define crop_age <[location].flag[crop_age]>
            - define parsed_name <[name_color]><[name]>
            - define built_seed_item <item[<[item]>].with[display=<[parsed_name].parsed>;hides=all;enchantments=<map[unbreaking=1]>].with_flag[crop:true].with_flag[crop_id:<[crop_id]>]>
            - flag <[location]> crop:!
            - flag <[location]> crop_id:!
            - flag <[location]> crop_age:!
            - if <[crop_age]> < 7:
                - drop <[built_seed_item]> at:<[location]>
                - stop
            - drop <[built_seed_item]> quantity:<[seed_drop_amount]> at:<[location]>
            - foreach <[drops]> as:drop_raw:
                - define drop_item <[drop_raw].split.get[1]>
                - if <[drop_raw].split.get[2].exists>:
                    - define drop_amount <[drop_raw].split.get[2]>
                - else:
                    - define drop_amount 1
                - if <[drop_raw].split.get[3].exists>:
                    - define drop_chance <[drop_raw].split.get[3]>
                - else:
                    - define drop_chance 1
                - if <util.random.decimal> >= <[drop_chance]>:
                    - foreach next
                - drop <[drop_item]> at:<[location]> quantity:<[drop_amount]>
            - flag server crop_blocks:<server.flag[crop_blocks].exclude[<[location]>]>
        on delta time secondly:
            - foreach <server.flag[crop_blocks]> as:crop_block:
                - foreach next if:<[crop_block].chunk.is_loaded.not>
                - if <[crop_block].material.name> == air || <[crop_block].has_flag[crop_id].not> || <[crop_block].has_flag[crop_id].not>:
                    - flag <[crop_block]> crop:!
                    - flag <[crop_block]> crop_id:!
                    - flag <[crop_block]> crop_age:!
                    - flag server crop_blocks:<server.flag[crop_blocks].exclude[<[crop_block]>]>
                - foreach next if:<[crop_block].flag[crop_age].is_more_than_or_equal_to[7]>
                - if <util.random.decimal> >= <script[crop_data].data_key[crops.<[crop_block].flag[crop_id]>.growth_chance]>:
                    - foreach next
                - else:
                    - flag <[crop_block]> crop_age:+:1
                    - define age <[crop_block].flag[crop_age]>
                    - choose <[crop_block].material.name>:
                        - case beetroots:
                            - choose <[age]>:
                                - case 0 1:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=0]>
                                - case 2 3 4:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=1]>
                                - case 5 6:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=2]>
                                - case 7:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=3]>
                        - case carrots:
                            - choose <[age]>:
                                - case 0 1:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=0]>
                                - case 2 3:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=3]>
                                - case 4 5 6:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=6]>
                                - case 7:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=7]>
                        - case wheat:
                            - choose <[age]>:
                                - case 0 1:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=0]>
                                - case 2 3:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=3]>
                                - case 4 5 6:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=6]>
                                - case 7:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=7]>
                        - case potatoes:
                            - choose <[age]>:
                                - case 0 1:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=0]>
                                - case 2 3:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=3]>
                                - case 4 5 6:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=6]>
                                - case 7:
                                    - adjust <[crop_block]> block_type:<[crop_block].material.with[age=7]>
