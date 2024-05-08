random_damage_world:
    type: world
    events:
        on player damaged:
        - if <server.flag[random_damage]> == <&c>비활성화됨:
            - stop
        - define origin_damage <context.damage>
        - define random_num <util.random.decimal[1].to[20]>
        - define cause <context.cause>
        - if <[cause]> != CUSTOM:
            - determine passively <[random_num]>
            - actionbar "<&7>입은 피해: <&c><[random_num].round>" targets:<context.entity>