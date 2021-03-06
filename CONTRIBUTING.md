
Содержание
=================

  * [Изменение файлов .proto](#Изменение-файлов-proto)
    * [Необходимые инструменты](#Необходимые-инструменты)
    * [Компиляция файлов .proto](#Компиляция-файлов-proto)
  * [Юнит-тесты](#Юнит-тесты)
  * [Самостоятельная сборка библиотек](#Самостоятельная-сборка-библиотек)
    * [protobuf-lua](#protobuf-lua)
    * [lzmq](#lzmq)
  
Изменение файлов .proto
--------
### Необходимые инструменты
  * <b>Python 2.7.x</b>
    <br/>Взять интерпретатор Python версии `2.7.x` можно отсюда: https://www.python.org.
    
  * <b>protobuf-lua</b>
    <br/>В комплект входит lua-библиотека для сериализации/десериализации и плагин для компилирования .proto-файлов в .lua-файлы.
    <br/>В самом начале использовался https://github.com/urbanairship/protobuf-lua, но в процессе использования его пришлось слегка модифицировать и поправить, поэтому актуальный инструмент нужно брать отсюда: https://github.com/Enfernuz/protobuf-lua.
    
    <br/>Если у вас Windows, то далее нужно проделать некоторые манипуляции:
    1. Файлу `protoc-plugin/protoc-gen-lua` технически является скриптом на Python, поэтому желательно добавить ему расширение `.py`: `protoc-plugin/protoc-gen-lua.py`;
    2. Рядом с файлом `protoc-plugin/protoc-gen-lua.py` создать файл `protoc-gen-lua.bat` следующего содержания:
    ```
    @echo off
    chdir MY_PATH
    python -u protoc-gen-lua.py
    ```
    , где вместо MY_PATH подставить директорию с файлом `protoc-plugin/protoc-gen-lua.py` (например, `D:\projects\protobuf-lua-master\protoc-plugin\`)
    
  * <b>protobuf</b>
    <br/>Скачать и распаковать компилятор `protobuf` отсюда: https://github.com/google/protobuf/releases.
    <br/>Будем считать, что у вас версия для Windows (например, `protoc-3.5.1-win32.zip`).
  
### Компиляция файлов .proto
  Допустим, в директории `D:\my-proto-files` имеется некий файл `facebook.proto` следующего содержания:
  ```
  syntax = "proto3";
  
  message Person {
        
    string name = 1;
    int32 age = 2;
  }
  
  ```
  Подробный мануал по синтаксисам protobuf можно найти здесь: <a href='https://developers.google.com/protocol-buffers/docs/proto3'>proto3</a> и <a href='https://developers.google.com/protocol-buffers/docs/proto2'>proto2</a>.
  
  Чтобы превратить его в соответствующий .lua-файл, нужно сделать следующее:
  1. В командной строке запустить компилятор protobuf (`папка_с_protobuf/bin/protoc.exe`) со следующими параметрами:
  `--plugin=protoc-gen-lua=PATH_TO_BAT_FILE --lua_out=PATH_OUT --proto_path=PATH_TO_DIR_WITH_FILE PATH_TO_PROTO_FILE`,
  где 
  * `PATH_TO_BAT_FILE` -- путь до файла `protoc-gen-lua.bat`;
  * `PATH_OUT` -- директория, в которую надо поместить скомпилированный .lua-файл;
  * `PATH_TO_DIR_WITH_FILE` -- директория, в которой компилятор будет искать импортируемые .proto-схемы. Является необязательным параметром и пригождается в случае импортирования .proto-схем в другие .proto-схемы;
  * `PATH_TO_PROTO_FILE` -- путь до компилируемой .proto-схемы.
  
  Например, полная команда может выглядеть так:
  ```
  protoc --plugin=protoc-gen-lua="D:\protobuf-lua\protoc-plugin\protoc-gen-lua.bat" --lua_out=./  --proto_path="D:\my-proto-files" D:\my-proto-files\facebook.proto
  ```
  <br/>Компилировать можно как несколько файлов в одной директории, так и несколько файлов в разных директориях:
  ```
  protoc --plugin=protoc-gen-lua="D:\protobuf-lua\protoc-plugin\protoc-gen-lua.bat" --lua_out=./  --proto_path="D:\my-proto-files" D:\my-proto-files\*.proto D:\my-other-proto-files\other.proto D:\more-proto-files\*.proto
  ```
  <br/>Более подробную инструкцию найдёте в мануале к компилятору `protoc`.
  <br/>На выходе получится файл `facebook_pb.lua`, который можно подключить и использовать в своём скрипте:
  ```lua
  local facebook = require('facebook_pb')
  local person = facebook.Person()
  person.name = "Jenny"
  person.age = 20
  
  local serialized_person = person:SerializeToString()
  local deserialized_person = facebook.Person()
  deserialized_person:ParseFromString(serialized_person)
  ```
  При этом подразумевается, что `protobuf-lua` установлена в качестве библиотеки в ваш Lua-интерпретатор:
  1. директория `protobuf` из инструмента `protobuf-lua` находится в директории подключаемых модулей вашего Lua-интерпретатора. В случае с QUIK это папка `%PATH_TO_QUIK%/lua/`, в случае standalone-интерпретатора это обычно директория самого интепретатора.
  2. файл `pb.dll` находится в директории подключаемых библиотек вашего Lua-интерпретатора. В случае с QUIK это директория `%PATH_TO_QUIK%/Include/protobuf/`, в случае LuaForWindows это директория  `%PATH_TO_LUA%/clibs`.
  <br/>Подробнее об установке `protobuf-lua` в качестве Lua-библиотеки можно прочесть в пункте [protobuf-lua](#protobuf-lua).

Юнит-тесты
--------
TO BE DESCRIBED

Самостоятельная сборка библиотек
--------
### protobuf-lua
  #### Необходимые инструменты
  Для того, чтобы определиться со списком необходимых инструментов, нужно понять, что мы будем делать. Конечной задачей всех манипуляций является получение DLL-файла, к которому будет обращаться Lua-интерпретатор при использовании Lua-библиотеки `protobuf-lua`. Исходный код целевого файла находится в файле `protobuf-lua/protobuf/pb.c`. Заглядывая в этот файл, видим, что там подключаются заголовки типа `lua.h`, `lualib.h` -- это заголовочные файлы Lua-интерпретатора.
  <br/>Соответственно, нам нужен компилятор C и заголовочные файлы Lua-интерпретатора (а лучше сразу весь дистрибутив интерпретатора, на всякий случай).
  * <b>Компилятор C</b>
    <br/>Воспользуемся `GCC`. 
    <br/>Для Windows нужно установить MinGW + MSYS: https://sourceforge.net/projects/mingw/files/ (кнопка Download Latest Version). При установке MinGW не забудьте выбрать пункт установки MSYS. MinGW уже содержит в себе GCC.
  * <b>Lua-интерпретатор</b>
    * <b>standalone</b>
      <br/>Для Windows Lua-интепретатор можно взять, например, отсюда: https://github.com/rjpcomputing/luaforwindows/releases.
    * <b>embedded</b>
      <br/>Lua-интерпретатор можно установить в составе менеджера пакетов <b>LuaRocks</b>. Подробнее можно прочитать в пункте [Установка LuaRocks](#Установка-luarocks).<br/>
      
  #### Компиляция DLL
  Использовался GCC следующей версии:
  ```
  $ gcc --version
  gcc.exe (MinGW.org GCC-6.3.0-1) 6.3.0
  ```
  1. В терминале MSYS переместиться в папку `protobuf-lua/protobuf`, где находится файл `pb.c`;
  
  2. Чтобы файл скомпилировался под Windows, нужно убрать/закомментировать строчки 23-33:
  ```C
  #if defined(_ALLBSD_SOURCE) || defined(__APPLE__)
  #include <machine/endian.h>
  #else
  #include <endian.h>
  #endif
  ```
    
  Эти строчки можно убрать безболезненно, т.к. процессоры архитектуры x86 и amd64 имеют little endianness, так что препроцессор не вставит функции из `endian.h`, которые используются далее в файле, в конечный код.
  
  3. Получить DLL: 
  ```
  gcc -O3 -shared -o pb.dll pb.c -I%PATH_TO_LUA%/include -L%libraries_folder% -l%lua_library%`
  ```
  , где %PATH_TO_LUA% -- путь до дистрибутива интерпретатора Lua, `%libraries_folder%` -- папка с .dll-библиотеками Lua, `%lua_library%` -- имя .dll-библиотеки Lua.
	
  Пример:
  * `%PATH_TO_LUA%` -- `D:/programs/LuaRocks/include`
  * `%libraries_folder%` -- `D:/QUIK`
  * `%lua_library%` -- `qlua`
  * Итого: `gcc -O3 -shared -o pb.dll pb.c -ID:/programs/LuaRocks/include -LD:/QUIK -lqlua`

  Линковать лучше с прокси-библиотекой Lua (`qlua.dll`), которая поставляется в коробке с QUIK. Не уверен, что если слинковаться с DLL из, например, Lua for Windows, или с той, что поставляется с LuaRocks, то всё будет работать. Линковка с прокси-библиотекой lua5.1.dll, которая находится в корне QUIK, технически осуществима, но на деле при запуске скрипта происходит ошибка из-за того, что pd.dll вызовет загрузку lua5.1.dll, которая не загружается по умолчанию, и чтобы её загрузить, загрузчик начнёт рыться в системных путях. У меня в системных путях никакой lua5.1.dll не было, от того и возникала ошибка. Линковка с qlua.dll не вызывает таких проблем, т.к. эта библиотека на момент загрузки pb.dll уже загружена терминалом.
  
  #### Установка в Lua-интерпретатор
  В сущности, нужно проделать два шага:
  1. Директорию `protobuf` с .lua-файлами библиотеки поместить в место, откуда Lua-интерпретатор резолвит Lua-модули, загружаемые директивой `require`.
  2. Файл `pb.dll` обернуть в директорию `protobuf`, и положить эту директорию в место, откуда Lua-интерпретатор резолвит бинарные модули (dll, lib, so, a и т.д), загружаемые директивой `require`.
  ##### QUIK
  1. Директорию `protobuf` с .lua-файлами библиотеки, находящуюся в директории `protobuf-lua`, поместить в `%PATH_TO_QUIK%/lua/`;
  2. Файл `pb.dll` нужно поместить в директорию `%PATH_TO_QUIK%/Include/protobuf/` , где `%PATH_TO_QUIK%` -- путь до терминала QUIK (например, `D:/QUIK`). Если папки `Include` нет, необходимо её создать.
  ##### LuaForWindows
  1. Директорию `protobuf` с .lua-файлами библиотеки, находящуюся в директории `protobuf-lua`, поместить в директорию c Lua-интерпретатором.
  2. Файл `pb.dll` нужно поместить в директорию `%PATH_TO_LUA%/clibs/protobuf`, где `PATH_TO_LUA` -- путь до директории с Lua-интерпретатором.
  
### lzmq
Для сборки Lua-биндинга для ZeroMQ `lzmq` нам понадобятся:
1. менеджер Lua-пакетов `LuaRocks`;
2. `Microsoft Visual Studio` с компонентами для разработки на C/C++. От выбранной версии (помимо всяческих доработок компилятора) будет зависеть максимальная версия toolset'а (следовательно, версия VC++ redistributable package -- набор библиотек, которые надо будет поставить на систему, в которой будет крутиться QUIK и RPC-сервис).

#### Установка LuaRocks

1. Где взять
	* Архивы с дистрибутивами: http://luarocks.github.io/luarocks/releases/
	* Инструкцию по установке можно найти здесь: https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Windows
2. Разархивировать, в командной строке Windows (cmd.exe) перейти в разархивированную папку.
3. Установить: `install.bat /NOREG /L /P %PATH_TO_LUAROCKS%`, где %PATH_TO_LUAROCKS% -- путь, куда нужно установить LuaRocks. Например, `D:/Programs/Lua/LuaRocks`.

	Почитав мануал, опции для установки можете настроить по своему вкусу.
	Например, /L значит "установить также дистрибутив Lua в папку с LuaRocks" -- он нам пригодится далее, т.к. не у всех стоит отдельный дистрибутив Lua.

	На самом деле, нам нужна не вся Lua, а её бинарники (.dll) и заголовочные файлы. Если не хотите ставить ту, что идёт с LuaRocks, то минимальный набор файлов можно взять здесь: http://luabinaries.sourceforge.net/download.html (например, `lua-5.3.4_Win32_bin.zip`). Качать нужно 32-битные версии (Win32), т.к. QUIK использует 32-битную Lua.
	
#### Шаги по сборке lzmq
Lua-биндинг `lzmq` линкуется с DLL ZeroMQ, поэтому нашей задачей будет собрать эту DLL.

Будем собирать `libzmq` версии `4.2.3`. Для этого нам нужно склонировать git-репозиторий `libzmq` и сделать чекаут тега `v4.2.3`: https://github.com/zeromq/libzmq.git

Для тех, кто не силён в работе с Git, можно скачать исходные коды напрямую: <br/>
https://github.com/zeromq/libzmq/archive/v4.2.3.zip

Здесь может возникнуть вопрос: <i>зачем нам самим собирать `libzmq`, а не взять уже готовую DLL, скажем, отсюда:</i> http://zeromq.org/distro:microsoft-windows?

<b>Ответ:</b> в RPC-сервисе используется аутентификация в том числе с помощью механизма CURVE, который был реализован после версии `4.0.4` (на текущий момент, эта версия -- самая новая из тех, что есть по вышеуказанной ссылке). Соответственно, эти DLL нам не подходят, и нужно собирать более новую версии `libzmq` самим.

Кстати, о CURVE. Это протокол, использующий криптографию, и в ZeroMQ он реализуется с помощью криптографических библиотек: `libsodium` или `nacl`. В RPC-сервисе он используется для аутентификации и шифрования. 
Для сборки `libzmq` я выбрал `libsodium`, так что надо будет собрать и её.

Будем собирать `libsodium` версии `1.0.16`. Для этого нам нужно склонировать git-репозиторий `libzmq` и сделать чекаут тега `1.0.16`: https://github.com/jedisct1/libsodium.git

Для тех, кто не силён в работе с Git, можно скачать исходные коды напрямую: <br/>
https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz <br/>
или https://github.com/jedisct1/libsodium/archive/1.0.16.zip

Суммируя вышесказанное, шаги по сборке `lzmq` следующие:
1. Собрать LIB (для статической линковки) или DLL (для динамической линковки) библиотеки `libsodium`;
2. Собрать DLL `libzmq`, слинковав её с `libsodium`;
3. Установить `lzmq` в `LuaRocks`, слинковав её с собранной ранее библиотекой `libzmq`.
4. Установленную `lzmq` переносим в директорию терминала QUIK.

#### Разбираемся с каждым шагом подробно
##### Шаг 1: Сборка libsodium
1. Открываем проект `libsodium` в Visual Studio.<br/>
2. Выбираем желаемую конфигурацию: `Release` для получения статической (.lib) библиотеки или `ReleaseDLL` для динамической (.dll):<br/>
![Выбор конфигурации](https://i.imgur.com/OnSSYRj.png "Выбор конфигурации")<br/>
3. Выбираем Runtime Library: `/MT` или `/MD`. Что выбрать -- вопрос философский. В большинстве случаев рекомендуется `/MD` (кстати, именно из-за него нужно будет ставить `VC++ redistributable package` на систему с QUIK).
Подробнее про эти флаги можно прочитать, например, здесь:<br/>
https://msdn.microsoft.com/en-us/library/2kzt1wy3.aspx<br/>
https://social.msdn.microsoft.com/Forums/en-US/9474efb9-49cd-46e1-8935-ee2bebe95203/difference-in-mt-and-md-run-time-lib-setting?forum=vcgeneral (пост *paercebal*)<br/>
https://stackoverflow.com/questions/757418/should-i-compile-with-md-or-mt<br/>
![Выбор RTL](https://i.imgur.com/feEsCaa.png "Выбор RTL")<br/>
4. Запускаем сборку проекта. Собирается не мгновенно -- потерпите (хотя, при выборе флага Runtime Library `/MD` собирается быстро, так как валятся тесты :) ).<br/>
![Сборка](https://i.imgur.com/pHxlsJd.png "Сборка")<br/>
5. Если всё прошло успешно (так ведь?), то на выходе получится файл библиотеки. Если ничего не настраивали, то искать его нужно в папке проекта. Пример:<br/>
![Расположение файла библиотеки](https://i.imgur.com/Ueu6zEH.png "Расположение файла библиотеки")<br/>
При сборке .dll (конфигурация `ReleaseDLL`) файл .lib тоже будет валяться неподалёку, однако будет значительно худее того .lib, который собирается в конфигурации `Release`. Это т.н. библиотека импорта (подробнее https://stackoverflow.com/questions/3573475/how-does-the-import-library-work-details).

##### Шаг 2: Сборка libzmq
1. Открываем проект `libzmq` в Visual Studio. Солюшены для Visual Studio гнездятся по пути `%libzmq_folder%/builds/msvc/`. Выбирайте подходящую для Вашей версии Visual Studio директорию. Более новые версии Visual Studio могут собирать проекты, созданные в более старых. Насчёт наоборот не уверен.<br/>
![Расположение проектов MSVC](https://i.imgur.com/vZlp3rI.png "Расположение проектов MSVC")<br/>
2. Если открыли проект от более старой Visual Studio, то Вам может быть предложено обновить тулсет и платформу проекта до тех, которые используются в Вашей Visual Studio. Обновляйте по своему усмотрению. Однако учтите, что если оставить всё как есть, то в Вашей Visual Studio может не оказаться нужной версии тулсета и SDK (где их взять и как поставить -- отдельная песня). 
Вот пример того, что предлагает Visual Studio 2017 при открытии проекта из директории `vs2015`:<br/>
![Обновление инструментов](https://i.imgur.com/6VbcTz0.png "Обновление инструментов")<br/>
3. Заходим в свойства модуля `libzmq`.<br/>
![Свойства libzmq](https://i.imgur.com/IuM1uEb.png "Свойства libzmq")<br/>
4. Опционально можем выбрать другой тулсет и/или SDK. Если собираем для Windows XP, то выбор тулсета с суффиксом `_xp` <b>обязателен</b>.
Версия тулсета помимо прочего определяет то, какую версию `VC++ redistributable package` надо будет поставить на систему с QUIK.<br/>
![Выбор тулсета](https://i.imgur.com/aEmv1Tx.png "Выбор тулсета")<br/>
Версия SDK помимо прочего определяет, на какой системе сможет работать собранная библиотека. Версии Windows обратно совместимы, то есть, на Windows 10 пойдут библиотеки, собранные с SDK 7.1 и 8.1, но не наоборот. Windows XP Service Pack 3 может использовать библиотеки, собранные с Windows SDK 7.1, но не выше. Таким образом, для сборки под Windows XP нужно будет поставить Windows SDK 7.1.<br/>
![Выбор платформы](https://i.imgur.com/CpjI2Ql.png "Выбор платформы")<br/>
Если интересно, пример обзора кросс-компиляции под различные версии Windows можно посмотреть здесь: 
https://poweruser.blog/visual-studio-2017-compile-against-older-visual-c-c-runtimes-372519fe1400<br/>
5. Заходим в `ZMQ Options` и отключаем использование `Tweet NaCl` (т.к. вместо него мы будем использовать `sodium`).<br/>
![Отключение NaCl](https://i.imgur.com/yMFf7Co.png "Отключение NaCl")<br/>
![Включение sodium](https://i.imgur.com/TZ6K6Bp.png "Включение sodium")<br/>
6. Следующий шаг: добавить директорию с заголовочными файлами от `libsodium` в пути компилятора.<br/>
![Заголовочные файлы sodium](https://i.imgur.com/3NcLVjN.png "Заголовочные файлы sodium")<br/>
Она находится в проекте `libsodium`: `src/libsodium/include` и `src/libsodium/include/sodium`:<br/>
![Заголовочные файлы sodium](https://i.imgur.com/sAH1RAo.png "Заголовочные файлы sodium")<br/>
7. Теперь добавим саму библиотеку `libsodium` в пути линкера.<br/>
![Линковка sodium](https://i.imgur.com/9G4IQZI.png "Линковка sodium")<br/>
Укажем файл библиотеки (не важно, как Вы собирали `libsodium` -- линковаться мы будем с .lib-файлом):<br/>
![Линковка sodium](https://i.imgur.com/XNthqA9.png "Линковка sodium")<br/>
Укажем линкеру, где искать этот файл:<br/>
![Линковка sodium](https://i.imgur.com/P4nfRyd.png "Линковка sodium")<br/>
Директория с библиотекой находится там, куда мы её (библиотеку) собрали на шаге сборки `libsodium`. Пример со статической библиотекой:<br/>
![Линковка sodium](https://i.imgur.com/D0uLBdc.png "Линковка sodium")<br/>
В случае, если Вы собирали `libsodium` как статическую библиотеку, нужно сообщить об этом препроцессору, <br/>
![Линковка sodium](https://i.imgur.com/vWIgC8A.png "Линковка sodium")<br/>
добавив директиву `SODIUM_STATIC`:<br/>
![Линковка sodium](https://i.imgur.com/6AP0Yv6.png "Линковка sodium")<br/>
8. Выбираем Runtime Library. Лучше выбрать тот же флаг RTL, который был выбран при сборке `libsodium`.<br/>
![Выбор RTL](https://i.imgur.com/CnlOgp1.png "Выбор RTL")<br/>
9. Запускаем сборку проекта.<br/>
10. Если сборка прошла успешно, то на выходе получится файл библиотеки. Пример с DLL:<br/>
![После сборки](https://i.imgur.com/y9GUo90.png "После сборки")<br/>

##### Шаг 3: Установка lzmq с помощью LuaRocks
Необходимые инструменты:<br/>
1. `LuaRocks`<br/>
2. `Developer Command Prompt for VS %YOUR_VISUAL_STUDIO_VERSION%` -- командная строка разработки от Visual Studio.
Можно её не ставить, но тогда нужно убедиться, что директория с компилятором `cl` и линкером `link` от Visual Studio находится в `PATH`.<br/>

Дальнейшие шаги:<br/>
1. В `Developer Command Prompt` перейти по пути `%PATH_TO_LUAROCKS%` (путь, куда установили LuaRocks).<br/>
2. Выполнить команду: <br/>
`luarocks install lzmq %LZMQ_VERSION% ZMQ_INCDIR="%PATH_TO_ZMQ_SOURCES%/include" ZMQ_LIBDIR="%PATH_TO_ZMQ_BINARIES%"`, где `%LZMQ_VERSION%` -- желаемая версия `lzmq` (если не указывать, то будет собираться последняя имеющаяся), `%PATH_TO_ZMQ_SOURCES%` -- директория с исходнными кодами библиотеки ZMQ, `%PATH_TO_ZMQ_BINARIES%` - директория, где находится библиотека импорта `libzmq.lib` (её мы получили на шаге 2).<br/>
Пример:<br/>
![lzmq via LuaRocks](https://i.imgur.com/xTdzaSW.png "lzmq via LuaRocks")<br/>
Список версий `lzmq` можно посмотреть здесь: https://luarocks.org/modules/moteus/lzmq<br/>
<br/>
После установки `lzmq` расположится в двух местах:</br>
1. .dll-файлы в `%PATH_TO_LUAROCKS%/systree/lib/lua/5.1` (путь после `%PATH_TO_LUAROCKS%` у вас может отличаться, если при установке LuaRocks вы использовали опцию `/TREE %dir%`).<br/>
2. .lua-файлы в `%PATH_TO_LUAROCKS%/systree/share/lua/5.1`.<br/>

##### Шаг 4: Установка lzmq в QUIK
1. Директорию `lzmq` и файл `lzmq.dll` из `%PATH_TO_LUAROCKS%/systree/lib/lua/5.1` скопировать в `%PATH_TO_QUIK%/Include`.<br/>
2. Директорию `lzmq` из `%PATH_TO_LUAROCKS%/systree/share/lua/5.1` скопировать в `%PATH_TO_QUIK%/lua`.<br/>
3. Файл `libzmq.dll`, полученный на шаге сборки `libzmq` скопировать в `%PATH_TO_QUIK%`. Если `libzmq.dll` Вы собирали с динамической линковкой к `libsodium`, то файл `libsodium.dll` также нужно скопировать в `%PATH_TO_QUIK%`.<br/>
