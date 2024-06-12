chain_event_handler:
    type: world
    events:
        on delta time secondly:
        - if <server.flag[chain]> == <&c>비활성화됨:
            - stop
        - define variance <proc[chain_get_variance]>
        - actionbar "<&f> <[variance.x].round_to[3]>" targets:<server.online_players>

chain_give_damage:
    type: task
    definitions: amount
    script:
    - foreach <server.online_players> as:target:
        - hurt <[amount]> <[target]> cause:CUSTOM

chain_get_average:
    type: procedure
    script:
    - define sum.x 0
    - define sum.y 0
    - define sum.z 0
    - foreach <server.online_players> as:player:
        - define sum.x:+:<[player].location.x>
        - define sum.y:+:<[player].location.y>
        - define sum.z:+:<[player].location.z>
    - define avg.x <[sum.x].div[<server.online_players.size>]>
    - define avg.y <[sum.y].div[<server.online_players.size>]>
    - define avg.z <[sum.z].div[<server.online_players.size>]>
    - determine <[avg]>

chain_get_variance:
    type: procedure
    script:
    - define avg <proc[chain_get_average]>
    - define variance.x 0
    - define variance.y 0
    - define variance.z 0
    - foreach <server.online_players> as:player:
        - define deviation.x <[player].location.x.sub[<[avg.x]>]>
        - define deviation.x:*:<[deviation.x]>
        - define deviation.y <[player].location.y.sub[<[avg.y]>]>
        - define deviation.y:*:<[deviation.y]>
        - define deviation.z <[player].location.z.sub[<[avg.z]>]>
        - define deviation.z:*:<[deviation.z]>
        - define variance.x:+:<[deviation.x]>
        - define variance.y:+:<[deviation.y]>
        - define variance.z:+:<[deviation.z]>
    - define variance.x:/:<server.online_players.size>
    - define variance.y:/:<server.online_players.size>
    - define variance.z:/:<server.online_players.size>
    - determine <[variance]>