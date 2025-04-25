hpshow_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[hpshow]>:
            - flag server hpshow:<&c>비활성화됨

main_gui_item_hpshow:
    type: item
    material: golden_apple
    display name: <&a>탭 리스트 HP 표시
    lore:
    - <&f>
    - <&f> - <&7>탭 리스트에 HP를 표시합니다.
    - <&f> - <&7>현재 상태: <server.flag[hpshow]>
    - <&f>

hpshow_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - foreach <server.online_players> as:player:
        - run util_tablist_update def.player:<[player]> def.health:<[player].health.round_up> delay:1t