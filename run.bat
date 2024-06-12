set config=%1
set runtime="2024.4.1.202"

C:\ProgramData\GameMakerStudio2\Cache\runtimes\runtime-%runtime%\bin\igor\windows\x64\Igor.exe windows Run /rp="C:\ProgramData\GameMakerStudio2\Cache\runtimes\runtime-%runtime%" /uf=%docpath% /project="%~dp0crunchy.yyp" /config=%config%
