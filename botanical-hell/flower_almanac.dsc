flower_almanac:
    type: item
    material: book
    display name: <&6>Flower Almanac
    mechanisms:
        hides: all
    enchantments:
    - unbreaking:1
    recipes:
        1:
            type: shaped
            input:
            - gold_ingot|string|gold_ingot
            - ink_sac|book|feather
            - gold_ingot|*_seeds|gold_ingot

flower_almanac_use:
    type: world
    debug: false
    events:
        after player right clicks dandelion|poppy|blue_orchid|allium|azure_bluet|red_tulip|orange_tulip|white_tulip|pink_tulip|oxeye_daisy|cornflower|lily_of_the_valley with:flower_almanac:
            - if <context.location.has_flag[exotic_flower]>:
                - narrate "<italic>This flower appears to be exotic...<&r><&nl>Name: <&l><context.location.flag[exotic_id]><&r><&nl>Rarity: <context.location.flag[exotic_rarity]>"
                - playsound <context.location> sound:item_book_page_turn sound_category:master pitch:0.6
            - else:
                - define random <util.random.int[1].to[50]>
                - if <[random]> != 50 || <context.location.has_flag[almanac_tried]>:
                    - narrate "<italic>It appears to be a normal flower..."
                    - playsound <context.location> sound:item_book_page_turn sound_category:master pitch:1.0
                    - flag <context.location> almanac_tried:true
                    - stop
                - choose <context.location.material.name>:
                    - case dandelion:
                        - define flower_color Yellow
                    - case poppy red_tulip:
                        - define flower_color Red
                    - case blue_orchid cornflower:
                        - define flower_color Blue
                    - case allium pink_tulip:
                        - define flower_color Pink
                    - case azure_bluet lily_of_the_valley white_tulip oxeye_daisy:
                        - define flower_color White
                    - case orange_tulip:
                        - define flower_color Orange
                - define random <util.random.int[1].to[100]>
                - if <[random]> >= 1 && <[random]> <= 40:
                    - define flower_type <script[data_flower_types].data_key[common].random[1].get[1]>
                    - define rarity <&7>Common
                    - define color <&7>
                - else if <[random]> >= 41 && <[random]> <= 70:
                    - define flower_type <script[data_flower_types].data_key[uncommon].random[1].get[1]>
                    - define rarity <&a>Uncommon
                    - define color <&a>
                - else if <[random]> >= 71 && <[random]> <= 90:
                    - define flower_type <script[data_flower_types].data_key[rare].random[1].get[1]>
                    - define rarity <&b>Rare
                    - define color <&b>
                - else if <[random]> >= 91 && <[random]> <= 100:
                    - define flower_type <script[data_flower_types].data_key[unique].random[1].get[1]>
                    - define rarity <&c>Unique
                    - define color <&c>
                - define flower_adjective <script[data_flower_adjectives].data_key[adjectives].random[1].get[1]>
                - define name "<[flower_adjective]> <[flower_color]> <[flower_type]>"
                - flag <context.location> exotic_flower:true
                - flag <context.location> exotic_id:<[name]>
                - flag <context.location> exotic_rarity:<[rarity]>
                - narrate "<italic>This flower appears to be exotic...<&r><&nl>Name: <&l><[name]><&r><&nl>Rarity: <[rarity]>"
                - playsound <context.location> sound:item_book_page_turn sound_category:master pitch:0.6
