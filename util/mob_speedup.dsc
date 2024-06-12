mob_speedup:
    type: world
    events:
        after entity spawns:
        - if <server.flag[speedup]> == <&c>비활성화됨:
            - stop
        - adjust <context.entity> attribute_base_values:[generic.movement_speed=0.6]
        - adjust <context.entity> attribute_base_values:[generic.follow_range=128]