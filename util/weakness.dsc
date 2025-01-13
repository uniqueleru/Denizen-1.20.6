weakness_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[weakness]>:
            - flag server weakness:<&c>비활성화됨

main_gui_item_weakness:
    type: item
    material: wooden_sword
    display name: <&2>나약화
    lore:
    - <&f>
    - <&f> - <&7>플레이어가 주는 데미지가 항상 1이 됩니다.
    - <&f> - <&7>현재 상태: <server.flag[weakness]>
    - <&f>

weakness_world:
    type: world
    debug: false
    events:
        on entity damaged:
        - if <server.flag[weakness]> == <server.flag[text_disabled]>:
            - stop
        - if <context.damager.is_player>:
            - define tool <context.damager.item_in_hand.material>
            - if <[tool].contains_text[sword]>:
                - actionbar "<&e><[tool].translated_name>으로 <&7>세게 휘둘렀으나 칼날이 너무 무딘듯 하다.." targets:<context.damager>
            - else if <[tool].contains_text[pickaxe]>:
                - actionbar "<&e><[tool].translated_name>는 <&7>광물을 캘 때 쓰는거다." targets:<context.damager>
            - else if <[tool].contains_text[axe]>:
                - actionbar "<&e><[tool].translated_name>로 <&7>있는 힘껏 내리쳤으나 너무 무거워 제대로 내리치지 못했다.." targets:<context.damager>
            - else if <[tool].contains_text[bow]>:
                - actionbar "<&e><[tool].translated_name>로 <&7>쏜 화살의 화살촉이 부러졌다.. 아무래도 중국산인듯 하다." targets:<context.damager>
            - else:
                - actionbar "<&e><context.entity.translated_name>을(를) <&7>최대한 세게 쳤으나 팔에 힘이 들어가지 않는다.." targets:<context.damager>
            - determine 1