mmob_downscale_world:
    type: world
    events:
        after entity spawns:
        - if <server.flag[mob_downscale]> == <&c>비활성화됨:
            - stop
        - execute as_server: ""