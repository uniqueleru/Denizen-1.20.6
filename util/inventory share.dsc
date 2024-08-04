inventory_share_event_handler:
    debug: false
    type: world
    events:
        after player picks up item:
        - run copy_inventory_data def.origin:<player>
        after player clicks in inventory:
        - run copy_inventory_data def.origin:<player>
        after player drops item:
        - run copy_inventory_data def.origin:<player>
        after player dies:
        - run delete_inventory_on_death def.origin:<player>


delete_inventory_on_death:
    debug: false
    type: task
    definitions: origin
    script:
    - if <server.flag[share_inventory]> == <server.flag[text_disabled]>:
        - stop
    - foreach <server.online_players> as:target:
        - if <[origin]> == <[target]>:
            - foreach next
        - else:
            - repeat 27 as:count:
                - define slot <[count]>
                - define slot:+:9
                - inventory set d:<[target].inventory> slot:<[slot]> o:air
copy_inventory_data:
    debug: false
    type: task
    definitions: origin
    script:
    - if <server.flag[share_inventory]> == <server.flag[text_disabled]>:
        - stop
    - foreach <server.online_players> as:target:
        - if <[origin]> == <[target]>:
            - foreach next
        - else:
            - repeat 27 as:count:
                - define slot <[count]>
                - define slot:+:9
                - inventory set d:<[target].inventory> slot:<[slot]> o:<[origin].inventory.slot[<[slot]>]>