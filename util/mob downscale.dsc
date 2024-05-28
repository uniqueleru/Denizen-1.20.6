mmob_downscale_world:
    type: world
    events:
        after entity spawns:
        - if <server.flag[mob_downscale]> == <&c>비활성화됨:
            - stop
        - adjust <context.entity> attribute_base_values:[generic_scale=0.1]