block_mob_summon:
    debug: false
    type: task
    definitions: targ|loc|type
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


block_mob_block_break:
    type: world
    events:
        on block drops item from breaking:
        - if <server.flag[block_mob]> == <server.flag[text_disabled]>:
            - stop
        - if <util.random_chance[100]>:
            - run block_mob_summon def.targ:<player> def.loc:<context.location> def.type:<context.material>
        - if <util.random_chance[0.3]>:
            - repeat 30:
                - run block_mob_summon def.targ:<player> def.loc:<context.location> def.type:<context.material>

block_mob_death_event:
    type: world
    events:
        on entity dies:
        - if <context.damager.libsdisguise_is_disguised>:
            - if <context.damager.entity_type> == creeper:
                - determine "<context.entity.name>이(가) 블럭에게 폭파당했습니다"
            - else if <context.damager.entity_type> == skeleton:
                - determine "<context.entity.name>이(가) 블럭에게 저격당했습니다"
            - else:
                - determine "<context.entity.name>이(가) 블럭에게 살해당했습니다"


block_mob_make_random_hp:
    debug: false
    type: task
    definitions: ent
    script:
    - define random_num <util.random.int[1].to[50]>
    - adjust <[ent]> max_health:<[random_num]>
    #- announce "hp: <[random_num]>"
    - heal <[ent]>

block_mob_make_random_speed:
    debug: false
    type: task
    definitions: ent
    script:
    - define random_num <util.random.decimal[0.1].to[0.6]>
    #- announce "speed: <[random_num]>"
    - adjust <[ent]> speed:<[random_num]>

block_mob_make_random_damage:
    debug: false
    type: task
    definitions: ent
    script:
    - define random_num <util.random.int[1].to[15]>
    #- announce "dmg: <[random_num]>"
    - if <[ent].entity_type> != creeper:
        - adjust <[ent]> attribute_base_values:[generic.attack_damage=<[random_num]>]