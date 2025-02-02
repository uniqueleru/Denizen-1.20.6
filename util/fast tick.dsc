fast_tick_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[fast_tick]>:
            - flag server fast_tick:<&c>비활성화됨
        - else if <server.flag[fast_tick]> == <server.flag[text_enabled]>:
            - tick rate amount:60

main_gui_item_fast_tick:
    type: item
    material: clock
    display name: <&5>빨리 감기
    lore:
    - <&f>
    - <&f> - <&7>게임 시간이 매우 빠르게 흐릅니다.
    - <&f> - <&7>현재 상태: <server.flag[fast_tick]>
    - <&f>

fast_tick_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        - tick rate amount:60
    - else if <[toggle]> == off:
        - tick rate amount:20
