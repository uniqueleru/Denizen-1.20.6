# Script written by 어라랍(https://github.com/KDY05)

random_jump_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[random_jump]>:
            - flag server random_jump:<&c>비활성화됨

main_gui_item_random_jump:
    type: item
    material: golden_boots
    display name: <&3>랜덤 점프
    lore:
    - <&f>
    - <&f> - <&7>매번 점프의 강도가 랜덤으로 정해집니다.
    - <&f> - <&7>현재 상태: <server.flag[random_jump]>
    - <&f>

random_jump_world:
    type: world
    debug: false
    events:
        after player jumps:
        - if <server.flag[random_jump]> == <server.flag[text_disabled]>:
            - stop
        - define rand <util.random.int[1].to[100]>
        # 60%로 확률로 강화 0단계
        - if <[rand].is_more_than[40]>:
            - define power <util.random.decimal[0.2].to[0.6]>
        # 25% 확률로 강화 1단계
        - else if <[rand].is_more_than[15]>:
            - define power <util.random.decimal[0.6].to[1.4]>
        # 10% 확률로 강화 2단계
        - else if <[rand].is_more_than[5]>:
            - define power <util.random.decimal[1.4].to[2.6]>
        # 5% 확률로 강화 3단계
        - else:
            - define power 8.0
        # attribute 적용 (점프 이벤트를 받으면 다음 점프의 강도가 정해짐)
        - definemap spec:
               generic_jump_strength: <[power]>
        - adjust <player> attribute_base_values:<[spec]>

random_jump_off_task:
    type: task
    debug: false
    script:
    # 비활성화 시 기본 점프 강도로 복구. 놀랍게도 기본값이 저렇다.
    - definemap spec:
        generic_jump_strength: 0.41999998688697815
    - foreach <server.online_players> as:origin:
        - adjust <[origin]> attribute_base_values:<[spec]>
