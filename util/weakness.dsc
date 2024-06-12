weakness_world:
    type: world
    events:
        on entity damaged:
        - if <server.flag[weakness]> == <&c>비활성화됨:
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