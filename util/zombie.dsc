# Script written by 어라랍(https://github.com/KDY05)

zombie_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[zombie]>:
            - flag server zombie:<&c>비활성화됨

main_gui_item_zombie:
    type: item
    material: zombie_head
    display name: <&2>좀비화
    lore:
    - <&f>
    - <&f> - <&7>플레이어가 좀비화됩니다.
    - <&f> - <&e>주의: Depenizen과 Lib's Disguises,
    - <&f>   <&e>PacketEvents 플러그인이 필요합니다.
    - <&f> - <&7>현재 상태: <server.flag[zombie]>
    - <&f>

zombie_world:
    type: world
    debug: false
    events:
        on delta time secondly:
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        - foreach <server.online_players> as:origin:
            # 햇빛에 탐
            - if <[origin].location.world.is_day>:
                - if ( <[origin].location.highest.y> <= <[origin].location.y.sub[1]> ) && ( !<[origin].has_equipped[*_helmet]> ):
                    - burn <[origin]> duration:8
                    - actionbar "<&e>볕이 너무 뜨겁다!" targets:<[origin]>
            # 주민 강제 타격
            - define vil <[origin].eye_location.ray_trace_target[range=4.0;entities=villager;raysize=1.0]||null>
            - if <[vil]> != null:
                - hurt 3 <[vil]> cause:ENTITY_ATTACK source:<[origin]>
                - playsound <[origin].location> sound:ENTITY_ZOMBIE_AMBIENT volume:1.0 pitch:1.0
                - actionbar "<&e>좀비의 본능으로 어쩔 수 없이 주민을 때리고 말았다." targets:<[origin]>
            # 철골렘 적대
            - foreach <[origin].location.find_entities[iron_golem].within[15]> as:golem:
                - attack <[golem]> target:<[origin]>

        on player kills villager:
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        # 주민 좀비화(+ 직업, 나이 구현)
        - flag server prof:<context.entity.profession>
        - if <context.entity.is_baby>:
            - flag server age:baby
        - else:
            - flag server age:adult
        - define rand <util.random.int[1].to[2]>
        - if <[rand]> == 1:
            - spawn zombie_vil_with_prof <context.entity.location> persistent

        on player heals:
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        # 체력 자연 재생 불가
        - if <context.reason> == SATIATED || <context.reason> == EATING:
            - actionbar "<&e>몬스터는 체력이 재생되지 않는다." targets:<player>
            - determine cancelled

        on player dies:
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        # 사망 시 보유 아이템 대신 썩은고기 드랍
        - define rand <util.random.int[1].to[3]>
        - drop rotten_flesh <player.location> quantity:<[rand]>
        - playsound <player.location> sound:ENTITY_ZOMBIE_DEATH volume:1.0 pitch:1.0
        - determine NO_DROPS

        on player damaged:
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        - playsound <player.location> sound:ENTITY_ZOMBIE_HURT volume:1.0 pitch:1.0

        on player damages entity:
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        - playsound <player.location> sound:ENTITY_ZOMBIE_AMBIENT volume:0.5 pitch:1.0
        - actionbar "<&e>좀비의 완력으로 더 강하게 타격했다." targets:<player>

        on player joins:
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        - libsdisguise mob type:ZOMBIE target:<player> display_name:<player.name><&7>(였던것) self

zombie_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        - foreach <server.online_players> as:origin:
            # 좀비 기본 스펙 적용(공격력 3, 방어력 2)
            - definemap spec:
                generic_attack_damage: 3.0
                generic_armor: 2.0
            - adjust <[origin]> attribute_base_values:<[spec]>
            # 좀비로 변장
            - libsdisguise mob type:ZOMBIE target:<[origin]> display_name:<[origin].name><&7>(였던것) self
    - else if <[toggle]> == off:
        - foreach <server.online_players> as:origin:
            - definemap spec:
                generic_attack_damage: 1.0
                generic_armor: 0.0
            - adjust <[origin]> attribute_base_values:<[spec]>
            - libsdisguise remove target:<[origin]>

zombie_vil_with_prof:
    type: entity
    entity_type: zombie_villager
    mechanisms:
        profession: <server.flag[prof]>
        age: <server.flag[age]>