start cmd /c setsvc sgrmbroker 4
start cmd /c setsvc wscsvc 4
start cmd /c setsvc securityhealthservice 4
sc config KeyIso Start= disabled