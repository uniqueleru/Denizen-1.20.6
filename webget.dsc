webget_chat_test:
  type: command
  usage: /webget
  description: SZSB
  name: webget
  script:
    - define url "https://chzzk.naver.com/chat/fb8bc2963a78051c98852e362bbef31f"
    - ~webget <[url]> save:web
    - narrate "Website content: <entry[web].result>"
