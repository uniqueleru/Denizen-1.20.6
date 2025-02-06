mob_spawnlimit_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[mob_spawnlimit]>:
            - flag server mob_spawnlimit:<&c>비활성화됨

main_gui_item_mob_spawnlimit:
    type: item
    material: spawner
    display name: <&4>몬스터 스폰 증가
    mechanisms:
        hides: ALL
    lore:
    - <&f>
    - <&f> - <&7>몬스터의 스폰이 100배 증가합니다.
    - <&f> - <&7>현재 상태: <server.flag[mob_spawnlimit]>
    - <&f>

mob_spawnlimit_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        - foreach <server.worlds> as:world:
            - adjust <[world]> monster_spawn_limit:7000
    - else if <[toggle]> == off:
        - foreach <server.worlds> as:world:
            - adjust <[world]> monster_spawn_limit:70