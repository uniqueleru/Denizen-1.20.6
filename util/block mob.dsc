block_mob_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[block_mob]>:
            - flag server block_mob:<&c>비활성화됨

main_gui_item_block_mob:
    type: item
    material: diamond_ore
    display name: <&b>블록 몬스터화
    lore:
    - <&f>
    - <&f> - <&7>블록을 캐면 일정 확률로 몬스터화됩니다.
    - <&f> - <&e>주의: Depenizen과 Lib's Disguises,
    - <&f>   <&e>PacketEvents 플러그인이 필요합니다.
    - <&f> - <&7>현재 상태: <server.flag[block_mob]>
    - <&f>

block_mob_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - stop

block_mob_block_break:
    type: world
    debug: false
    events:
        on block drops item from breaking:
        - if <server.flag[block_mob]> == <server.flag[text_disabled]>:
            - stop
        - if <util.random_chance[3]>:
            - run block_mob_summon def.targ:<player> def.loc:<context.location> def.type:<context.material>
        - if <util.random_chance[0.3]>:
            - repeat 30:
                - run block_mob_summon def.targ:<player> def.loc:<context.location> def.type:<context.material>

block_mob_death_event:
    type: world
    debug: false
    events:
        on player dies:
        - if <server.flag[block_mob]> == <server.flag[text_disabled]>:
            - stop
        - define damager <context.damager||null>
        - if <[damager]> == null:
            - stop
        - if <[damager].libsdisguise_is_disguised>:
            - if <[damager].entity_type> == creeper:
                - determine "<context.entity.name>이(가) 블럭에게 폭파당했습니다"
            - else if <[damager].entity_type> == skeleton:
                - determine "<context.entity.name>이(가) 블럭에게 저격당했습니다"
            - else:
                - determine "<context.entity.name>이(가) 블럭에게 살해당했습니다"

block_mob_summon:
    type: task
    definitions: targ|loc|type
    debug: false
    script:
    - if <server.flag[block_mob]> == <server.flag[text_disabled]>:
        - stop
    - define random_num <util.random.int[1].to[7]>
    - if <[random_num]> == 1:
        - define disguised_block <entity[spider]>
    - if <[random_num]> == 2:
        - define disguised_block <entity[zombie]>
    - if <[random_num]> == 3:
        - define disguised_block <entity[skeleton]>
    - if <[random_num]> == 4:
        - define disguised_block <entity[enderman]>
    - if <[random_num]> == 5:
        - define disguised_block <entity[creeper]>
    - if <[random_num]> == 6:
        - define disguised_block <entity[ghast]>
    - if <[random_num]> == 7:
        - define disguised_block <entity[warden]>
    - spawn <[disguised_block]> <[loc]> target:<[targ]> save:sentity
    - equip <entry[sentity].spawned_entity> head:iron_helmet
    - libsdisguise misc target:<entry[sentity].spawned_entity> type:Falling_Block id:<[type].name>
    - run block_mob_make_random_hp def.ent:<entry[sentity].spawned_entity>
    - run block_mob_make_random_speed def.ent:<entry[sentity].spawned_entity>
    - run block_mob_make_random_damage def.ent:<entry[sentity].spawned_entity>


block_mob_make_random_hp:
    type: task
    definitions: ent
    debug: false
    script:
    - define random_num <util.random.int[1].to[50]>
    #- announce "hp: <[random_num]>"
    - adjust <[ent]> max_health:<[random_num]>
    - heal <[ent]>

block_mob_make_random_speed:
    type: task
    definitions: ent
    debug: false
    script:
    - define random_num <util.random.decimal[0.1].to[0.6]>
    #- announce "speed: <[random_num]>"
    - adjust <[ent]> speed:<[random_num]>

block_mob_make_random_damage:
    type: task
    definitions: ent
    debug: false
    script:
    - define random_num <util.random.int[1].to[15]>
    - if <[ent].has_attribute[generic_attack_damage]>:
        #- announce "dmg: <[random_num]>"
        - adjust <[ent]> attribute_base_values:[generic_attack_damage=<[random_num]>]