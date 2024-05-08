jump_share_world:
    type: world
    events:
        on player jumps:
        - run jump_share_task def.origin:<player>

jump_share_task:
    type: task
    definitions: origin
    script:
    - if <server.flag[jump_share]> == <&c>비활성화됨:
        - stop
    - foreach <server.online_players> as:target:
        - if <[origin]> == <[target]>:
            - foreach next
        - else:
            - define current_location <[target].location.above[1.5]>
            - push <[target]> origin:<[current_location]> destination:<[current_location]> speed:0.5 duration:1t no_rotate