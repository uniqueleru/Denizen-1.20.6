random_pickup_init:
    type: world
    events:
        on scripts loaded:
        - if !<server.has_flag[random_pickup]>:
            - flag server random_pickup:<server.flag[text_disabled]>

main_gui_item_random_pickup:
    type: item
    material: diamond
    display name: <&6>아이템 랜덤 줍기
    lore:
    - <&f>
    - <&f> - <&7>아이템 랜덤 줍기 여부를 결정합니다.
    - <&f> - <&7>현재 상태: <server.flag[random_pickup]>
    - <&f>

random_pickup_event_handler:
    type: world
    debug: false
    events:
        on player picks up item:
        - if <server.flag[random_pickup]> == <server.flag[text_disabled]>:
            - stop
        - run random_pickup_task def.player:<player> def.item:<context.item>
        - remove <context.entity>
        - determine cancelled

random_pickup_task:
    type: task
    definitions: player|item
    script:
    - define list <list>
    - define item_name <[item].material.translated_name>
    - foreach <server.online_players> as:target:
        - if <[target].inventory.can_fit[<[item]>]>:
            - define list:->:<[target]>
    - define random_player <[list].random>
    - give <[item]> player:<[random_player]>
    - if <[random_player]> != <[player]>:
        - actionbar "<&7>당신이 주운 <[item].quantity>개의 <&f><[item_name]>을(를) <&e><[random_player].flag[tabname]>이(가) <&7>대신 먹었다!" targets:<[player]>
        - actionbar "<&e><[player].flag[tabname]>이(가) <&7>주운 <[item].quantity>개의 <&f><[item_name]>을(를) <&7>대신 먹었다!" targets:<[random_player]>
    - playsound <[random_player]> sound:ENTITY_ITEM_PICKUP pitch:1 volume:0.2