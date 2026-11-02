# MAG-Ecosystem-Legacy — Посібник користувача

Версія документа: 0.1.1.

Цей посібник пояснює, як отримати й використовувати MAG-Ecosystem-Legacy. Він описує інструменти, які є в цьому репозиторії. Він не додає можливостей і не замінює історичні документи з урядування. Якщо посібник розходиться зі скриптом або з [docs/INSTALL.md](../INSTALL.md), доказом використання є скрипт і посібник зі встановлення, а цей посібник треба виправити.

Версія 0.1.1 — це цільова версія документації для цього пакунка. Це не реліз GitHub, не публічне оприлюднення і не реєстрація продукту в MAG Development Center.

<!-- mag-item-id: 3aa1c41a-7fa6-45e3-82d7-b6ed36412e3d -->
## 1. Що таке MAG-Ecosystem-Legacy

MAG-Ecosystem-Legacy зберігає історичний розвиток MAG Ecosystem, багатокласової основи розробки програмного забезпечення для роботи з допомогою ШІ. Ця історія охоплює глобальне урядування, операції з документацією, маршрутизацію знань і інструменти Cursor.

Репозиторій зберігає цю історію розробки в очищеному вигляді. Практичні інструменти, якими й далі можна користуватися:

- документи урядування в корені репозиторію
- шаблони документів XenForo в `templates/xenforo-addon/`
- Knowledge Index і Locator у `tools/knowledge/`
- правило керування знаннями для Cursor у `tools/cursor/`
- необов'язковий Model Routing Guard у `tools/model-routing-guard/`
- необов'язкове Documentation Mirror у `tools/docs/`

Згенеровані індекси та базові знімки Mirror у `generated/` є похідними. Вони ігноруються Git і не є авторитетом.

<!-- mag-item-id: 95defc9e-e5ed-4373-9141-68924c79a3f6 -->
## 2. Стан і супровід

Розробку MAG Ecosystem у цьому репозиторії закрито. Репозиторій супроводжується як історичний запис і як придатний до використання знімок його інструментів. Це не активна лінія розробки.

Поточні факти про репозиторій:

- Видимість — **PRIVATE**.
- Публічне оприлюднення — **pending**. Його не схвалено, і цей посібник не робить репозиторій готовим до оприлюднення.
- Ціль документації — 0.1.1. Створення цих посібників не створює Git-тег і не створює реліз GitHub.
- Встановлення на іншому комп'ютері з Windows (**clean-machine installation**) — **NOT VERIFIED**. Команди в цьому посібнику відповідають скриптам цього checkout. Їх перевіряли на машині автора, зокрема в ізольованих тимчасових фікстурах. Ці фікстури не є успішним встановленням на окремому ПК.

Не змінюйте видимість репозиторію і не переписуйте історію, крім окремо дозволеного кроку.

<!-- mag-item-id: 598ff436-2d44-497d-8c21-036a68c5f6af -->
## 3. Зв'язок із MAG Development Center

[MAG Development Center](https://magshifter.com/resources/magdc-evidence-driven-control-plane.14/) (MAGDC) — окремий проєкт-наступник: площина урядування та доказів. MAGDC не є сумісною заміною середовища виконання для MAG-Ecosystem-Legacy.

MAGDC не виконує ці спадкові інструменти. Міграція, спільне середовище виконання чи міст сумісності не заявляються. Не вважайте, що команда MAGDC запускає Knowledge, правило Cursor, Model Routing Guard або Documentation Mirror.

Ідентифікатор `mag-ecosystem-legacy` у `source.json` називає лише цей пакунок документації. Він не реєструє продукт MAGDC, каталожний `product_id` і не призначає talk handle. У цьому репозиторії немає `.magdc/product.yaml`.

Історичні документи урядування в цьому репозиторії лишаються описом поведінки Legacy. Документація MAGDC визначає формат цього посібника, а не середовище виконання цих інструментів.

<!-- mag-item-id: d520443d-2c3c-42f1-b8b6-ed3eabf09f5b -->
## 4. Компоненти

Для Knowledge **GLOBAL** потрібне лише мінімальне налаштування. Усе інше необов'язкове або історичне.

<!-- mag-item-id: b40c6065-1510-4d39-94ca-fc1978f55f2c -->
### 4.1 Мінімальне налаштування

| Компонент | Розташування | Що він робить |
| --- | --- | --- |
| Документація урядування | Кореневі `AI_*.md` і `MAG_*.md` | Історичні правила процесу й агентів. Лише Markdown. Нічого встановлювати. |
| Шаблони документів XenForo | `templates/xenforo-addon/` | Стартовий пакунок `P0N__XXX__*.md` для продуктів-додатків XenForo `#N`. Лише Markdown. Нічого встановлювати. |
| Knowledge Index і Locator, **GLOBAL** | `tools/knowledge/` | Будує, перевіряє й опитує детермінований індекс глобальних документів. Потрібні цей checkout і PowerShell 7. |

<!-- mag-item-id: a8f76674-aff4-4841-b6d3-227ba41a2533 -->
### 4.2 Необов'язкові інтеграції

| Компонент | Розташування | Що він робить |
| --- | --- | --- |
| Правило керування знаннями для Cursor | `tools/cursor/` | Файл правила, який ви копіюєте в робочий простір Cursor, і перевірка розбіжності лише для читання. |
| Model Routing Guard | `tools/model-routing-guard/` | Хуки Cursor для примусового дотримання маршрутизації моделей. Розгортання **змінює** `<ReposRoot>\.cursor\hooks.json`. |
| Documentation Mirror | `tools/docs/` | Копіює перелічені файли між checkout репозиторіїв і окремою транспортною текою. `-BootstrapClean` **видаляє** все під коренем Mirror, перш ніж скопіювати джерела назад. |
| Knowledge **GLOBAL+#5** | `tools/knowledge/manifests/global-5.json` | Необов'язкова область індексу. Справжній індекс потребує checkout `Beyond3DViewer` поруч із цим репозиторієм. |

<!-- mag-item-id: 3faa4c59-9b69-4dc3-b680-c4709b9ce338 -->
### 4.3 Історичний і експериментальний матеріал

- `MAG_PIPELINE_V2_EVALUATION.md` і `MAG_PIPELINE_V2_EXPERIMENT.md` фіксують закритий експеримент. Вони не є глобальним авторитетом і не потрібні для налаштування.
- Документи урядування фіксують середовище автора, зокрема шляхи `C:\laragon\repos\...` і пронумеровані продукти. Ці шляхи — історичні записи, а не типові значення для встановлення.
- `tools/docs/mirror-inventory.json` — інвентар Documentation Mirror автора. Він використовується лише тоді, коли ви передаєте його явно. Незалежне використання починайте з `tools/docs/mirror-inventory.example.json`.

<!-- mag-item-id: fde35453-9ffe-456a-83a2-9ad51a9ff346 -->
## 5. Середовище та передумови

Початкове підтримуване середовище:

- Windows
- PowerShell 7 (`pwsh`). Кожен скрипт інструмента містить `#Requires -Version 7.0`. Windows PowerShell 5.x (`powershell.exe`) їх не запускає.
- Git у `PATH`. Під час генерації Knowledge читає Git blob id джерела, якщо присутній каталог `.git`.
- Cursor — лише для правила керування знаннями та Model Routing Guard.

Скрипти не встановлюють пакунки NuGet чи модулі PowerShell і не завантажують залежності.

Перевірка PowerShell 7:

```text
pwsh -NoProfile -Command '$PSVersionTable.PSVersion'
```

Запускайте команди з кореня репозиторію, теки, де лежать `MAG_ECOSYSTEM.md` і `tools/`. Назва теки не має значення. Інструменти знаходять свій checkout за шляхом скрипта. Шляхи з пробілами приймаються.

Ці назви в старіших документах означають ваш checkout цього репозиторію, хоч би як називалася тека:

- `MAG-Ecosystem`
- `<MAG-Ecosystem>`

Checkout автора лежав у `C:\laragon\repos\MAG-Ecosystem`. Це розташування не є типовим.

`C:\laragon\repos` використовують Cursor Check, Guard або Mirror лише тоді, коли ви явно передаєте або налаштовуєте цей шлях.

<!-- mag-item-id: 702c034f-b48f-4e9d-a7b5-1600593e67a7 -->
## 6. Отримання та встановлення

URL репозиторію:

```text
https://github.com/Magshifter/MAG-Ecosystem-Legacy.git
```

Поки репозиторій **PRIVATE**, клонуйте його лише обліковим записом GitHub, якому надано доступ. Входьте через помічник облікових даних. Не вміщуйте пароль або токен в URL клонування чи в скрипт.

Приклади входу:

- Git Credential Manager, що входить до Git for Windows, може відкрити вхід через браузер під час першого клонування.
- GitHub CLI: один раз виконайте `gh auth login`, потім клонуйте через `git` або `gh repo clone Magshifter/MAG-Ecosystem-Legacy`.

Після оприлюднення той самий URL працював би без входу. Оприлюднення не схвалено.

Приклад із батьківської теки, якою ви керуєте:

```text
cd "D:\Work\My Repos"
git clone https://github.com/Magshifter/MAG-Ecosystem-Legacy.git
cd MAG-Ecosystem-Legacy
```

Очікувана структура:

```text
MAG-Ecosystem-Legacy/
  AI_*.md, MAG_*.md
  templates/
  tools/knowledge/
  tools/cursor/
  tools/model-routing-guard/
  tools/docs/
  generated/
```

`generated/` створюють інструменти. Не комітьте його.

Мінімальне налаштування — розділ 7. Cursor, Guard, Mirror і GLOBAL+#5 не потрібні для Knowledge **GLOBAL**.

<!-- mag-item-id: 5baba111-e036-47ee-ac84-201961a25941 -->
## 7. Knowledge GLOBAL

Knowledge **GLOBAL** — самостійна область. Вона індексує глобальні документи, перелічені за базовим ім'ям у `tools/knowledge/manifests/global.json`, і записує `generated/knowledge/index-global.json`.

Індекс похідний, необов'язковий і не є авторитетом. Locator повертає вказівник. Він не друкує тіла документів і не вирішує, що документ застосовний. Попередній згенерований файл не є останнім добрим знанням. Коли індексу немає або він застарів, згенероване виявлення закривається відмовою, а запасним шляхом лишається читання канонічних документів тієї самої області.

Призначувані робочі ідентичності та рецепти згенерованих індексів — різні речі. Locator приймає `GLOBAL`, `GLOBAL+#N` і `GLOBAL+A<N>`. `B<N>` і `GLOBAL+B<N>` зарезервовані й відхиляються. `GLOBAL+#5` — це не `GLOBAL+A5`. Чинна ідентичність `GLOBAL+A<N>` не означає файл індексу A. Не вигадуйте `index-global-a1.json` чи будь-яке ім'я файлу A/B.

Підтримувані наміри: `GOVERN`, `PLAN`, `IMPLEMENT`, `DEBUG`, `VERIFY` і `LEARN`.

<!-- mag-item-id: 933e0812-17dd-4f5d-acbb-3e527bcdd1d2 -->
### 7.1 Генерація та перевірка

З кореня репозиторію:

```text
pwsh ./tools/knowledge/Generate-MagKnowledgeIndex.ps1 `
  -Manifest ./tools/knowledge/manifests/global.json
```

`-Manifest` обов'язковий. Успішний запуск друкує `OK` із кількістю одиниць і джерел та шляхом виводу.

Перевірте згенерований індекс тим самим маніфестом:

```text
pwsh ./tools/knowledge/Validate-MagKnowledgeIndex.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Manifest ./tools/knowledge/manifests/global.json
```

`-Index` обов'язковий. Успіх друкує `VALID`.

Помилки використання завершуються кодом `5`. Проблеми генерації та перевірки, які не є помилками використання, завершуються кодом `3`.

<!-- mag-item-id: 8eb06953-bc05-4020-80dd-215da69c9ce9 -->
### 7.2 Пошук вказівника

```text
pwsh ./tools/knowledge/Locate-MagKnowledge.ps1 `
  -Index ./generated/knowledge/index-global.json `
  -Identity GLOBAL `
  -Intent GOVERN `
  -Query "Documentation authority model"
```

Обов'язкові параметри: `-Index`, `-Identity`, `-Intent` і `-Query`. `-Owner` необов'язковий.

Locator не перегенеровує індекс і не відкриває документ за вас. Результат `FOUND` містить `owner`, `section`, `heading_path`, `unit_id`, `identity_scope`, `knowledge_class` і `source_id`. Тіла розділу він не містить.

| Стан | Код | Значення |
| --- | --- | --- |
| `FOUND` | 0 | Один відповідний вказівник. |
| `NOT_FOUND` | 1 | Немає збігу в індексі. Це не доказ, що знання немає в документах. |
| `AMBIGUOUS` | 2 | Більш ніж один збіг. |
| `STALE` / `CONFLICT` | 3 | Індексу немає або він не збігається з байтами джерел, зокрема `missing_index`. |
| `OUT_OF_SCOPE` | 4 | Ідентичність поза цим індексом, зокрема зарезервована ідентичність. |
| використання / введення-виведення | 5 | Бракує обов'язкового параметра або шлях не читається. |

Зіставлення — це точно нормалізований заголовок або, коли в запиті щонайменше два токени, присутність кожного токена в заголовку чи шляху заголовків. Часткове перекриття одним токеном дає `NOT_FOUND`, якщо заголовок не збігається точно.

Застарілість порівнює SHA-256 поточних байтів джерела з `sources[].content_sha256`. Git blob id є додатковим і дорівнює null, коли файл не відстежується.

<!-- mag-item-id: 4d2d3d08-d0c2-4ae0-b952-7c3b90f1a5e8 -->
### 7.3 Оновлення після змін документів

Після зміни індексованого документа згенеруйте й перевірте індекс знову або скористайтеся скриптом оновлення.

Типово оновлення вибирає лише `tools/knowledge/manifests/global.json`. Йому не потрібен `Beyond3DViewer`, і воно не чіпає GLOBAL+#5.

```text
pwsh ./tools/knowledge/Update-MagKnowledge.ps1 -DryRun
pwsh ./tools/knowledge/Update-MagKnowledge.ps1
```

`-DryRun` повідомляє зачеплені області й не записує індекси. `-ChangedFiles` можна додати до множини змінених шляхів. Скрипт не пише в Google Drive, не комітить і не встановлює Git-хуки. Locator ніколи його не викликає.

| Результат | Значення |
| --- | --- |
| `NO_INDEXED_SOURCE_CHANGE` | Нічого індексованого не змінилося. Індекси не перегенеровуються і не пересертифіковуються. |
| `DRY_RUN` | Зачеплені області повідомлено. Запису згенерованих файлів немає. |
| `UPDATED` | Кожен зачеплений маніфест згенеровано, а потім перевірено. |
| `FAILED` | Генерацію зупинено. Згенероване виявлення для невдалих областей непридатне. Читайте канонічні документи цих областей. Код виходу `3`. |

Технічні подробиці: [tools/knowledge/README.md](../../tools/knowledge/README.md).

<!-- mag-item-id: 3cdc6606-5e23-4ed0-bab0-5d809dae3906 -->
## 8. Необов'язковий GLOBAL+#5

GLOBAL+#5 — приклад області, а не частина мінімального налаштування. Маніфест — `tools/knowledge/manifests/global-5.json`. Справжній індекс — `generated/knowledge/index-global-5.json`, а ідентичність Locator — `GLOBAL+#5`.

Маніфест перелічує конкретні файли в `../Beyond3DViewer/docs/` з іменами `P05__3DR__*.md`. Генерація закривається відмовою, коли цього сусіднього checkout або цих файлів немає. Сканування сусідніх тек немає.

Оновлюйте цю область, лише явно вибравши каталог маніфестів:

```text
pwsh ./tools/knowledge/Update-MagKnowledge.ps1 -ManifestDirectory ./tools/knowledge/manifests
```

Ця команда вибирає кожен маніфест `*.json` у теці, включно з GLOBAL+#5. Якщо вибраному маніфесту бракує джерел, оновлення повідомляє `FAILED`, завершується кодом `3` і не замінює наявні індекси. Серед причин є `missing_development_root` і `missing_source`.

`tools/knowledge/tests/MagKnowledge.Tests.ps1` покриває GLOBAL+#5 синтетичними документами в `.mag-kn-test/`. Ця фікстура не є справжнім checkout `Beyond3DViewer`, і набір не записує справжній `index-global-5.json`. Якщо `.mag-kn-test/` уже існує, набір зупиняється з `FAIL fixture-root-preexisting` і не видаляє її. Огляньте цю теку й видаліть її вручну перед повторним запуском.

<!-- mag-item-id: d86eb3dc-1940-43b6-9d2d-53bf06e492f4 -->
## 9. Правило керування знаннями для Cursor

Цей компонент необов'язковий. Knowledge **GLOBAL** його не потребує.

Відстежуване джерело:

```text
tools/cursor/mag-knowledge-control.mdc
```

Cursor завантажує копію за шляхом:

```text
<ReposRoot>\.cursor\rules\mag-knowledge-control.mdc
```

`<ReposRoot>` — тека, яку ви відкриваєте як робочий простір Cursor. Якщо ви відкриваєте лише цей репозиторій, Cursor не завантажить правило, скопійоване в батьківську теку.

Скрипта розгортання немає. Копіюйте джерело в робочий простір. Не копіюйте розгорнутий файл назад поверх відстежуваного джерела.

```text
$root = "D:\Work\My Repos"
New-Item -ItemType Directory -Force -Path "$root\.cursor\rules" | Out-Null
Copy-Item -LiteralPath .\tools\cursor\mag-knowledge-control.mdc -Destination "$root\.cursor\rules\mag-knowledge-control.mdc"
```

Перевірка розбіжності, лише читання:

```text
pwsh -NoProfile -File ./tools/cursor/Check-MagCursorKnowledgeControl.ps1 -ReposRoot "D:\Work\My Repos"
```

Явний `-ReposRoot` має пріоритет. Інакше скрипт використовує `MAG_REPOS_ROOT`. Якщо не задано жодного, він зупиняється. Шлях має бути абсолютним і вказувати на наявну теку. Немає відступу до поточної теки і немає типового Laragon.

| Код | Вивід | Значення |
| --- | --- | --- |
| 0 | `IDENTICAL` | Розгорнута копія збігається з відстежуваним джерелом. |
| 1 | `DRIFT` | Копії різняться. |
| 2 | `MISSING_SOURCE` | Відстежуваного джерела немає. |
| 3 | `MISSING_DEPLOYED` | Правила немає в `<ReposRoot>\.cursor\rules\`. |
| 4 | `INVALID_ROOT` | Корінь відсутній, відносний або не є текою. |

Текст правила використовує `<MAG-Ecosystem>` як шлях цього checkout, наприклад `<ReposRoot>\MAG-Ecosystem-Legacy`. Копіювання не встановлює Locator.

Посібник: [tools/cursor/README.md](../../tools/cursor/README.md).

<!-- mag-item-id: 233df203-2161-405f-82fe-3c5aaee4900c -->
## 10. Model Routing Guard

Guard необов'язковий. Він не потрібен для Knowledge **GLOBAL** і для правила Cursor.

Він розгортає хуки Cursor (`sessionStart`, `beforeSubmitPrompt`, `preCompact`) у робочий простір. Джерело істини — `tools/model-routing-guard/`. Розгорнуті файли йдуть у `<ReposRoot>\.cursor\hooks\model-routing-guard\`, а розгортання створює або оновлює `<ReposRoot>\.cursor\hooks.json`.

Контракт кореня збігається з перевіркою Cursor: явний `-ReposRoot`, інакше `MAG_REPOS_ROOT`, абсолютна наявна тека, без типового значення. Guard також відхиляє корінь диска, як-от `D:\`, і корінь, що містить `"`, `%`, `$` або зворотний апостроф, перш ніж щось запише.

<!-- mag-item-id: 6b88f7a5-0a2b-4637-9952-2bdfd1b0ac1b -->
### 10.1 Розгортання

Спочатку виконайте `-WhatIf`. Він розв'язує корінь, перевіряє наявний `hooks.json` і обчислює злиття без запису.

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos" -WhatIf
pwsh -NoProfile -File .\tools\model-routing-guard\Deploy-MagModelRoutingGuard.ps1 -ReposRoot "D:\Work\My Repos"
```

Розгортання є записом:

- Воно перезаписує файли, що належать Guard, у `.cursor\hooks\model-routing-guard\`.
- У `sessionStart`, `beforeSubmitPrompt` і `preCompact` воно замінює записи, чия команда містить `model-routing-guard`, рівно одним записом Guard.
- Інші записи хуків, інші події та інші параметри верхнього рівня зберігаються. Форматування JSON переписується.
- Команди хуків абсолютні й містять `-ReposRoot`, тож не залежать від робочої теки, з якої їх запускає Cursor.
- Відсутній, відносний шлях або корінь диска, недійсний JSON, значення `hooks`, що не є об'єктом, або ціль, що не є текою, відхиляються до будь-якого копіювання.

Збережіть резервну копію `.cursor\hooks.json`, якщо вам потрібно його відновити.

<!-- mag-item-id: db67d0f6-d39c-4bad-b7fb-e352e4261cd1 -->
### 10.2 Режим і обслуговування

Режим і обслуговування використовують той самий корінь. Обидва вимагають `-ProductOwnerApproved`. Стан зберігається в `<ReposRoot>\.mag\`.

Режими примусу: `Enforced`, `Advisory` і `Suspended`. Прийняті псевдоніми: `Pro`, `Auto`, `Off`, `ENFORCED`, `ADVISORY` і `SUSPENDED`.

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMode.ps1 -ReposRoot "D:\Work\My Repos" -Mode Advisory -ProductOwnerApproved
```

Обслуговування окреме від команди режиму. `-Action` — це `Suspend` або `Resume`.

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Suspend -ProductOwnerApproved
pwsh -NoProfile -File .\tools\model-routing-guard\Set-MagGuardMaintenance.ps1 -ReposRoot "D:\Work\My Repos" -Action Resume -ProductOwnerApproved
```

Без `-ProductOwnerApproved` ці скрипти зупиняються і нічого не записують. `Suspend`, коли обслуговування вже активне, зупиняється з `Maintenance already active.`

<!-- mag-item-id: 71e762f2-903b-455d-8ec7-0b854fa53df9 -->
### 10.3 Ризики та локальні тести

Розгортання змінює конфігурацію робочого простору Cursor. Невдале злиття відновлюється з вашої резервної копії `hooks.json`, а не автоматичним скасуванням у цьому репозиторії.

Ці тести використовують тимчасові корені. Їх проходження не перевіряє встановлення на чистому комп'ютері:

```text
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagModelRoutingGuard.ps1
pwsh -NoProfile -File .\tools\model-routing-guard\Test-GuardRecovery.ps1 -GuardRoot (Resolve-Path .\tools\model-routing-guard).Path
pwsh -NoProfile -File .\tools\model-routing-guard\Test-MagGuardPortability.ps1
```

Посібник: [tools/model-routing-guard/README.md](../../tools/model-routing-guard/README.md).

<!-- mag-item-id: 6bd7cc17-aafa-4e1d-9dc7-810935c3131b -->
## 11. Documentation Mirror

Documentation Mirror необов'язковий. Він не потрібен для Knowledge **GLOBAL**.

`tools/docs/Update-MagDocumentationMirror.ps1` копіює файли, названі в інвентарі, між канонічними checkout (Local) і окремою транспортною текою (Mirror). Порівняння використовує SHA-256. Інструмент записує базовий знімок. Він ніколи не стверджує, що хмарний диск щось відвантажив або завантажив. `drive_sync_claimed` завжди false.

<!-- mag-item-id: e103ec28-415a-4571-898c-025e4ae58dbd -->
### 11.1 Інвентар і корені

`-InventoryPath` обов'язковий. Типового інвентаря немає.

```text
Copy-Item .\tools\docs\mirror-inventory.example.json "D:\Work\mirror\my-inventory.json"
```

Відредагуйте копію:

- `repositories`: один ключ на ім'я теки безпосередньо під коренем репозиторіїв. Порожнє рядкове значення означає, що ім'я теки дорівнює ключу.
- `entries`: файли для дзеркалення. Кожен запис має `repo`, `path` відносно того репозиторію, `category` (`document` або `tool`) і `require_metadata`.
- `repos_root` і `mirror_root`: абсолютні шляхи або порожні рядки, коли ви щоразу передаєте `-ReposRoot` і `-MirrorRoot`. Значення командного рядка мають пріоритет над інвентарем.

Приклад інвентаря не перелічує приватні репозиторії. Інструменти не змінюють файл прикладу.

`tools/docs/mirror-inventory.json` — інвентар Laragon автора. Використовуйте його, лише передавши `-InventoryPath .\tools\docs\mirror-inventory.json`.

Оберіть окрему теку Mirror. Її батьківська тека вже має існувати. Сама тека Mirror може ще не існувати.

Корені мають бути абсолютними. Вони не розв'язуються від поточної теки. Пробіли дозволені. Корінь диска, як-от `D:\`, відхиляється. Mirror не може дорівнювати кореню репозиторіїв, містити його, перетинатися з переліченим репозиторієм, перетинатися з цим checkout, лежати всередині Git worktree або бути символічним посиланням чи junction. Шлях Mirror усередині кореня репозиторіїв дозволений, лише коли він не перетинається з переліченим репозиторієм.

Типові шляхи базового знімка й квитанції — `generated/docs-mirror/baseline.json` і `generated/docs-mirror/check-receipt.json` у цьому checkout. Кожен інвентар ділить ці типові значення. Передавайте окремі `-BaselinePath` і `-ReceiptPath` для кожного розташування.

<!-- mag-item-id: da825274-baa3-4d23-aa61-4c2f3a53f36d -->
### 11.2 Перевірка

`-Check` є типовим, коли ви не передаєте перемикач режиму. Передавайте лише один із `-Check`, `-BootstrapClean`, `-Reconcile` і `-PublishAffected`.

```text
pwsh -NoProfile -File .\tools\docs\Update-MagDocumentationMirror.ps1 -Check `
  -InventoryPath "D:\Work\mirror\my-inventory.json" `
  -BaselinePath "D:\Work\mirror\baseline.json" -ReceiptPath "D:\Work\mirror\check-receipt.json"
```

Check класифікує кожну пару, зокрема `IDENTICAL`, `MISSING_TARGET`, `NEWER_LOCAL` і `CONFLICT`. Він не записує Local, Mirror чи базовий знімок. Він записує квитанцію перевірки. Ця квитанція зв'язує пізніший `-Reconcile`, тож Check не є суворо лише читанням.

Завершений Check виходить із кодом `0`, навіть коли пари мають `MISSING_TARGET`. Читайте класифікації. Не вважайте код `0` доказом, що Mirror збігається з Local.

Запустіть Check знову після запису. Синхронізований Mirror повідомляє кожну пару як `IDENTICAL`.

<!-- mag-item-id: 3afbe88e-1271-4930-98e0-1e2f13219d6d -->
### 11.3 Записи, включно з BootstrapClean

| Режим | Що він записує |
| --- | --- |
| `-Check` | Лише квитанцію перевірки. |
| `-BootstrapClean` | Видаляє кожен файл і теку під коренем Mirror, потім копіює кожне джерело інвентаря з Local у Mirror, перевіряє SHA-256 і записує базовий знімок. |
| `-Reconcile` | Записує пари, запропоновані однією зв'язаною квитанцією Check, і оновлює базовий знімок. Потребує `-AuthorizationSha256`, встановленого в SHA-256 тієї квитанції. |
| `-PublishAffected` | Записує лише названі цілі Mirror, які новіші локально. Потребує шляхів `-Affected` і `-ProductOwnerApproved` та оновлює базовий знімок. |

`-BootstrapClean` ніколи не запускається через те, що інший режим пропущено. Перемикач треба передати явно. Перш ніж щось видалити, він відмовляє небезпечному кореню і відмовляє точці повторного розбору (symlink або junction) усередині дерева Mirror. Дані під цим коренем Mirror видаляються. Використовуйте його лише на окремій транспортній теці. Він не видаляє ваші канонічні репозиторії, коли перевірки кореня проходять, і не видаляє їх через наведення на репозиторій: такі корені відхиляються спершу.

`-Reconcile` закривається відмовою, якщо інвентар, базовий знімок, корені або файли змінилися після Check, який видав квитанцію.

Перевірки кореня й інвентаря виконуються до будь-якого запису, включно з квитанцією Check. Відхилення завершується кодом `5`, друкує причину в потік помилок і нічого не змінює. Поширені префікси: `usage: -InventoryPath is required`, `repos_root_missing`, `mirror_root_missing`, `*_relative`, `mirror_root_is_filesystem_root`, `mirror_root_overlaps_ecosystem_checkout`, `duplicate_mapping` і `reparse_point:`. Повний список є в [docs/INSTALL.md](../INSTALL.md).

`tools/docs/tests/MagDocumentationMirror.Tests.ps1` використовує одноразові фікстури TEMP. `MagDocumentationMirror.Portability.Tests.ps1` повідомляє `NOT VERIFIED`, коли розташування Laragon автора відсутнє. Жоден із цих тестів не є встановленням на чистому комп'ютері.

<!-- mag-item-id: 4abca998-05e7-4969-be68-601104bf7288 -->
## 12. Усунення несправностей

| Симптом | Що робити |
| --- | --- |
| `#Requires -Version 7.0` або скрипт не запускається | Використовуйте `pwsh`, а не Windows PowerShell 5.x. |
| `git clone` просить пароль або повертає `Repository not found` | Репозиторій приватний. Увійдіть через Git Credential Manager або `gh auth login`. Не вставляйте токен в URL. |
| Locator `STALE`, код `3` або `missing_index` | Згенеруйте й перевірте індекс знову. Locator не ремонтує індекс. |
| Locator `OUT_OF_SCOPE` для `GLOBAL+#5`, `A…` або `B…` | Ідентичність не відповідає цьому індексу, ідентичність зарезервована або необов'язкового рецепта індексу немає. |
| `Update-MagKnowledge.ps1` повідомляє `FAILED`, код `3` | Явно вибраному маніфесту бракує джерел. Типовий запуск оновлює лише GLOBAL. |
| `MagKnowledge.Tests.ps1` повідомляє `FAIL fixture-root-preexisting` | Лишилася `.mag-kn-test/`. Огляньте її й видаліть вручну. |
| Cursor Check `INVALID_ROOT`, код `4` | Передайте абсолютний наявний `-ReposRoot` або задайте `MAG_REPOS_ROOT`. |
| Cursor Check `MISSING_DEPLOYED` | Скопіюйте правило в `<ReposRoot>\.cursor\rules\` або ви перевірили інший корінь. |
| Guard `repos_root_not_configured` або `repos_root_not_found` | Корінь не передано або його не існує. Нічого не записано. |
| Guard `hooks_json_invalid` | Виправте `hooks.json` вручну. Розгортання нічого не записало. |
| Розгортання Guard змінило хуки, яких ви не очікували | Відновіть `hooks.json` із резервної копії, зробленої перед розгортанням. |
| Mirror `usage: -InventoryPath is required` | Скопіюйте `tools/docs/mirror-inventory.example.json` і передайте цю копію. |
| Mirror `repos_root_*`, `mirror_root_*`, код `5` | Корінь відсутній, відносний, зіпсований або небезпечний. Нічого не записано. |
| Bootstrap Mirror видалив файли | `-BootstrapClean` за задумом видаляє вміст кореня Mirror. |

<!-- mag-item-id: 29dd1a69-3009-4b3a-bce4-0ab29d208d09 -->
## 13. Безпека та збереження

- Тримайте репозиторій **PRIVATE**, доки не буде окремого рішення про оприлюднення. Не змінюйте видимість із цього посібника.
- Не вміщуйте паролі чи токени в URL клонування, скрипти або закомічені файли.
- Path B переніс очищену історію розробки в цей чистий репозиторій GitHub. Ця перенесена історія зберігає 103 коміти з метаданими author і committer GitHub noreply та історичні дерева джерел. Пізніші коміти документації є додатковими комітами поверх цієї історії. Вони не є втратою тих 103 комітів.
- Попередній архів, `Magshifter/MAG-Ecosystem-Legacy-Arhiv` (колишній ID `1442085997`), видалено.
- Застарілий коміт до очищення `442286df7cb2abff56e84064dd1ceb5a3594e9b8` недоступний через перевірені після того видалення автентифіковані кінцеві точки GitHub API. Видалений архів повертає 404. Git API цього репозиторію повертає 404. Його commits API повертає 422, `No commit found`.
- Недоступність через автентифікований API не доводить фізичного видалення з кожного кешу, резервної копії чи відновлюваного сховища GitHub.
- `-BootstrapClean` видаляє вміст кореня Mirror. `-Reconcile` і `-PublishAffected` записують копії Mirror або Local, названі інвентарем. Check не записує ці дерева, але записує квитанцію.
- Розгортання Guard переписує належні Guard записи хуків Cursor. Режим і обслуговування пишуть у `<ReposRoot>\.mag\` і вимагають `-ProductOwnerApproved`.
- Вивід `generated/` одноразовий. Його видалення не видаляє канонічні джерела Markdown. Перегенерація індексу не переписує ці джерела.

<!-- mag-item-id: ff108ca5-7564-4261-9ce3-fbae8b4c0588 -->
## 14. Обмеження

- Встановлення на окремому комп'ютері з Windows (**clean-machine installation**) — **NOT VERIFIED**.
- Публічне оприлюднення — **pending** і не схвалене. Цей пакунок не є релізом.
- Проходження тесту на фікстурі TEMP не означає, що сторонній розробник установив репозиторій.
- Необов'язкові компоненти не потрібні для Knowledge **GLOBAL**.
- Locator не застосовує Verified Applicability, не вибирає шаблони реалізації і не друкує текст документів.
- Наявні шаблони реалізації призначені для `#N`. `A<N>` не вибирає їх як застосовні інструкції. Відсутній індекс `A<N>` не є нечинною ідентичністю.
- Documentation Mirror не перевіряє хмарну синхронізацію.
- MAGDC не запускає ці інструменти.
- Ця документація не стверджує, що Phase 7, Gate 3 або Phase 8 життєвого циклу релізу пройдені.

<!-- mag-item-id: 2e0b0494-6c3a-45d5-88dc-143bfb5d9ff1 -->
## 15. Ліцензія та очікування щодо супроводу

Репозиторій має ліцензію MIT. Див. [LICENSE](../../LICENSE). Copyright (c) 2026 Magshifter. Програмне забезпечення надається як є, без гарантії.

Цей посібник не передбачає каналу підтримки. Репозиторій є історичним записом і придатним до використання знімком. Це не активна продуктова лінія, і ці посібники не обіцяють оновлень, сумісності з майбутніми версіями MAGDC чи оприлюдненого релізу.

<!-- mag-item-id: c89759c3-829f-4cd5-932f-01034bbbb299 -->
## 16. Подальше читання

- [README.md](../../README.md) — коротка точка входу, стан і запис історичного очищення.
- [docs/INSTALL.md](../INSTALL.md) — встановлення, відхилені шляхи Mirror і команди перевірки.
- [tools/knowledge/README.md](../../tools/knowledge/README.md) — контракт індексу й результати оновлення.
- [tools/cursor/README.md](../../tools/cursor/README.md) — правило Cursor.
- [tools/model-routing-guard/README.md](../../tools/model-routing-guard/README.md) — Guard.
- `AI_GUIDELINES.md`, `AI_AGENTS_RULES.md` і `MAG_ECOSYSTEM.md` — історичне урядування. Цей посібник їх не встановлює.
