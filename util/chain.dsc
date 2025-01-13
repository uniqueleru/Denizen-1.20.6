chain_init:
    type: world
    events:
        on scripts loaded:
        - if !<server.has_flag[chain]>:
            - flag server chain:<server.flag[text_disabled]>

main_gui_item_chain:
    type: item
    material: chain
    display name: <&6>연결고리
    lore:
    - <&f>
    - <&f> - <&7>너와 나의 연결고리(a.k.a. 강제협동)
    - <&f> - <&7>현재 상태: <server.flag[chain]>
    - <&f>

chain_event_handler:
    type: world
    debug: false
    events:
        on tick every:5:
        - if <server.flag[chain]> == <server.flag[text_disabled]>:
            - stop
        - if <server.flag[chain_damage_bypass]> > 0:
            - flag server chain_damage_bypass:--
            - stop
        - define finalValue <proc[chain_get_final_value]>
        - run chain_give_damage def.amount:<[finalValue]>
        on player uses portal:
        - flag server chain_damage_bypass:4

chain_give_damage:
    type: task
    definitions: amount
    debug: false
    script:
    - if <[amount]> <= 4:
        - define dmg 0
    - else:
        - define dmg <[amount].div[2]>
    - foreach <server.online_players> as:target:
        - hurt <[dmg]> <[target]> cause:CUSTOM
    - actionbar "<&7>떨어진 정도: <&e><[amount].round_to[1]> <&f>| <&7>받는 대미지: <&c><[dmg].round_to[1]>" targets:<server.online_players>

chain_get_average:
    type: procedure
    debug: false
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
    debug: false
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

chain_get_final_value:
    type: procedure
    debug: false
    script:
    - define variance <proc[chain_get_variance]>
    - define finalValue 0
    - define finalValue:+:<[variance.x]>
    - define finalValue:+:<[variance.y].div[10]>
    - define finalValue:+:<[variance.z]>
    - determine <[finalValue].sqrt>