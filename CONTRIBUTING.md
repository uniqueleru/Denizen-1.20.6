### util/ 경로에 새로운 스크립트를 추가하는 방법에 대한 문서입니다.

---

## 필수로 포함하여야 하는 컨테이너

util/ 경로에 새로운 스크립트 파일을 만드려면 gui.dsc와의 호환을 위해 다음 3개의 컨테이너를 필수로 포함해야 합니다.

1. \{파일명\}\_init : 해당 스크립트의 기능을 토글(활성화/비활성화)하기 위한 flag를 정의하는 컨테이너입니다. **flag의 이름은 파일명과 일치시키며**, 비활성화를 기본값으로 합니다. 파일명에 공백이 있다면 언더바(\_)로 대체합니다. 다음은 예시 컨테이너입니다.

```yaml
# 파일명: random item.dsc

random_item_init:
    type: world
    debug: false
    events:
        on scripts loaded:
        - if !<server.has_flag[random_item]>:
            - flag server random_item:<&c>비활성화됨 # 기능 토글을 위한 flag 정의
        # 내부 동작에 필요한 별도의 flag 정의도 가능합니다.
        - flag server random_item_running:false
```

2. main_gui_item_\{파일명\} : 토글 버튼을 누르는 gui에서 표시될 아이콘을 정의하는 컨테이너입니다. 아이콘의 material, 이름, 설명을 입력합니다. 현재 상태를 표시하는 라인에서 토글 flag를 입력합니다. 다음은 예시입니다.

```yaml
# 파일명: damage share.dsc

main_gui_item_damage_share:
    type: item
    material: iron_sword # 적절한 material
    display name: <&c>대미지 공유 # 적절한 이름, 색상 코드도 변경 가능
    mechanisms: # 칼의 피해량 정보 등을 감추어 주기 위한 key 입니다.
        hides: ALL
    lore:
    - <&f>
    - <&f> - <&7>플레이어 간 대미지가 공유됩니다. # 적절한 설명
    - <&f> - <&7>현재 상태: <server.flag[damage_share]> # 토글 flag 입력
    - <&f>
```

3. \{파일명\}_toggle_task: 기능을 활성화하거나, 비활성화하여 원상태로 다시 돌아오게 할 때에 필요한 코드가 있을 수 있습니다. 그러한 코드를 이 컨테이너에 입력하면 됩니다. 이 task는 사용자가 gui에서 토글 아이콘을 누를 때에 gui.dsc에서 실행하게 되므로, 별도로 이 task를 실행하기 위한 코드를 추가할 필요가 없습니다. 만약 이 컨테이너가 필요하지 않다면 \"- stop\" 라인 하나만 작성하여 둡니다. 다음은 두 가지 예시입니다.

```yaml
# 파일명: fast tick.dsc

fast_tick_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    - if <[toggle]> == on:
        # 활성화 시에 필요한 코드를 여기에 작성
        - tick rate amount:60
    - else if <[toggle]> == off:
        # 비활성화 시에 필요한 코드를 여기에 작성
        - tick rate amount:20
```

```yaml
# 파일명: block mob.dsc

block_mob_toggle_task:
    type: task
    definitions: toggle
    debug: false
    script:
    # 별도의 코드가 필요하지 않은 경우
    - stop
```

## gui.dsc에 추가해야 하는 코드

core/gui.dsc 에서는 두 군데만 고쳐주면 됩니다. 아래의 과정을 거치면 gui와 연동이 됩니다.

1. 마지막 gui 페이지인 main_gui_inventory_2 에서 아이콘의 이름을 적절한 위치의 대괄호 안에 넣어줍니다.

```yaml
main_gui_inventory_2:
    type: inventory
    inventory: CHEST
    title: 월드 옵션 토글
    size: 54
    gui: true
    definitions:
        bar: main_gui_bar
    slots: # 적절한 위치의 대괄호에 추가
    - [] [] [] [] [] [] [] [] []
    - [] [main_gui_item_random_jump] [] [main_gui_item_zombie] [] [main_gui_item_jump_share] [] [main_gui_item_random_pickup] []
    - [] [main_gui_item_hpshow] [] [main_gui_item_random_item] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [bar] [bar] [bar] [bar] [main_gui_page_2] [bar] [bar] [bar] [bar]
```

2. main_gui_world 컨테이너의 on player clicks in main_gui_inventory_2 부분에 다음과 같이 입력합니다.

```yaml
on player clicks in main_gui_inventory_2:
        - define item null
        - choose <context.item.script.name||null>:
            - case main_gui_item_random_jump:
                - define item random_jump
            - case main_gui_item_zombie:
                - define item zombie
            - case main_gui_item_random_pickup:
                - define item random_pickup
            - case main_gui_item_jump_share:
                - define item jump_share
            - case main_gui_item_hpshow:
                - define item hpshow
            - case main_gui_item_random_item:
                - define item random_item
            # 아래와 같이 추가
            #- case main_gui_item_{파일명}:
                #- define item {파일명}

            - case main_gui_page_2:
                - inventory open d:main_gui_inventory_1
```

## 코드 컨벤션

* 컨테이너 순서: 필수로 포함하여야 하는 컨테이너 3개를 순서대로 가장 앞에 두고, 나머지는 가독성에 따라 배치합니다.
* 가독성 및 호환성을 위해 각 컨테이너 이름은 해당 파일명으로 시작합니다. (gui 아이콘 제외)
* world 컨테이너가 기능 비활성화 상태에서는 실행되지 않도록 조건문으로 필터를 걸어줍니다.
```yaml
# zombie.dsc

on player heals:
        # 아래와 같이 조건문으로 걸러줍니다.
        - if <server.flag[zombie]> == <server.flag[text_disabled]>:
            - stop
        - if <context.reason> == SATIATED || <context.reason> == EATING:
            - actionbar "<&e>몬스터는 체력이 재생되지 않는다." targets:<player>
            - determine cancelled
```
* gui.dsc와 util.dsc를 제외한 다른 스크립트 파일에 의존하지 않도록 합니다.
* 의존하는 외부 플러그인이 있다면 gui 아이콘 설명에 적어 사용자가 알도록 합니다.

```yaml
# zombie.dsc

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
```
* 개발 완료 후 가능한 모든 컨테이너에 \"debug: false\" key를 포함시킵니다. 사용자 입장에서 콘솔 로그가 많이 뜨는 것을 방지하기 위함입니다.