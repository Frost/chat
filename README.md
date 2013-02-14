Chatt med [Socket.IO][1]
========================

Detta är ett exempel på en chatt i [Node.js][2] och [Socket.IO][1]. Tankten är att man ska skriva sin egen klient,
men jag har skrivit ett exempel på en för att underlätta. Ta en titt i källkoden för att få ett hum om det.

Dock bör det sägas att klienten är skriven i coffescript och att det du ser här är en kompilerad version. För att
se [källkoden](/coffeescript/client.js) kan du ändra _/javascript/_ till _/coffeescript/_.

Lyssna på eventet `"text"` där du får meddelanden på formatet
```
{
  at: Date // När det skickades
  user: String // Vilken användare det är
  text: String // Meddelandet
}
```

Skicka ert meddelande på samma event på formatet
``` 
{
  text: String // Meddelandet
}
```

För att sätta ert namn så skicka det på eventet "set" på formatet
``` 
{
  name: String // Ert nick
}
```

[1]: http://socket.io/
[2]: http://nodejs.org/
