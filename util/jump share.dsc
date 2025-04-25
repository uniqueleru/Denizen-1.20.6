jump_share_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[jump_share]>:
            - flag server jump_share:<&c>비활성화됨

main_gui_item_jump_share:
    type: item
    material: slime_block
    display name: <&3>점프 공유
    lore:
    - <&f>
    - <&f> - <&7>플레이어 간 점프를 공유합니다.
    - <&f> - <&7>현재 상태: <server.flag[jump_share]>
    - <&f>

jump_share_world:
    type: world
    debug: false
    events:
        on player jumps:
        - if <server.flag[jump_share]> == <server.flag[text_disabled]>:
            - stop
        - run jump_share_task def.origin:<player>

jump_share_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - stop

jump_share_task:
    type: task
    definitions: origin
    debug: false
    script:
    - foreach <server.online_players> as:target:
        - if <[origin]> == <[target]>:
            - foreach next
        - else:
            - define current_location <[target].location.above[1.5]>
            - push <[target]> origin:<[current_location]> destination:<[current_location]> speed:0.5 duration:1t no_rotate