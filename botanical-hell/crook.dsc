crook:
    type: item
    material: wooden_hoe
    display name: <white>Crook
    mechanisms:
        hides: all
    enchantments:
    - multishot:1
    recipes:
        1:
            type: shaped
            input:
            - stick|stick|air
            - air|stick|air
            - air|stick|air
        2:
            type: shaped
            input:
            - air|stick|stick
            - air|stick|air
            - air|stick|air

crook_use:
    type: world
    debug: false
    events:
        on player breaks *_leaves with:crook:
            - determine passively NOTHING
            - choose <context.location.material.name>:
                - case oak_leaves:
                    - drop oak_sapling <context.location> quantity:<util.random.int[1].to[3]>
                - case spruce_leaves:
                    - drop spruce_sapling <context.location> quantity:<util.random.int[1].to[3]>
                - case birch_leaves:
                    - drop birch_sapling <context.location> quantity:<util.random.int[1].to[3]>
                - case jungle_leaves:
                    - drop jungle_sapling <context.location> quantity:<util.random.int[1].to[3]>
                - case acacia_leaves:
                    - drop acacia_sapling <context.location> quantity:<util.random.int[1].to[3]>
                - case dark_oak_leaves:
                    - drop dark_oak_sapling <context.location> quantity:<util.random.int[1].to[3]>
        on player breaks grass|fern with:crook:
        - determine passively NOTHING
        - random:
            - drop wheat_seeds <context.location> quantity:<util.random.int[1].to[3]>
            - drop pumpkin_seeds <context.location> quantity:<util.random.int[1].to[3]>
            - drop melon_seeds <context.location> quantity:<util.random.int[1].to[3]>
            - drop beetroot_seeds <context.location> quantity:<util.random.int[1].to[3]>