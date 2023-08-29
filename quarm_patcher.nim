# nimble install zip
# nimble install nigui
# nimble install checksums
import
  std/[httpclient, os, osproc, strformat],
  zip/zipfiles,
  checksums/md5,
  nigui

proc log(ta: TextArea, msg: string): void =
  echo msg
  ta.addLine(msg)
  ta.scrollToBottom()

proc has_md5(fileName: string, md5eq: string): bool =
  var content: string = ""

  if fileExists(fileName):
    content = readFile(fileName)

  return md5eq == getMD5(content)

proc is_eqgame_ok(): bool =
  return "./eqgame.exe".has_md5("b86646f1a48990a9355644b6e146e70c")

proc is_eqdll_ok(): bool =
  return "./eqgame.dll".has_md5("63d2b77d7de61d88fdb2fb674077d511")

# TODO: Provide a list of files + destinations and handle programmatically
proc fetch_file_1(ta: TextArea): string =
  const
    url = "https://cdn.discordapp.com/attachments/1135981619858128998/1137492344162234368/projectquarm_08_05_2023.zip"
    filename = "quarm_latest.zip"

  ta.log("Fetching Project Quarm files...")
  let client = newHttpClient()
  let zipContent = client.getContent(url)

  writeFile(fileName, zipContent)
  ta.log("Files fetched successfully.")

  return fileName

proc unzip_file_1(ta: TextArea, filename: string): void =
  var z: ZipArchive

  if not z.open(filename):
    ta.log("Opening zip failed")
  else:
    # extracts all files from archive z to the destination directory.
    z.extractAll(".")
    ta.log("Zip files extracted")

# TODO: Provide a list of files + md5 sums and check programmatically
proc check_game(ta: TextArea): void =
  if is_eqgame_ok():
    ta.log("./eqgame.exe IS the expected version")
  else:
    ta.log("====================================================")
    ta.log("./eqgame.exe IS NOT the expected version - visit: ")
    ta.log("")
    ta.log("https://wiki.takp.info/index.php/Getting_Started_on_Windows#Obtaining_and_Running_the_Client")
    ta.log("")
    ta.log("to download the proper game files (use link #1)")
    ta.log("====================================================")

  if is_eqdll_ok():
    ta.log("./eqgame.dll IS the expected version")
  else:
    ta.log("====================================================")
    ta.log("./eqgame.dll IS NOT the expected version - click 'Patch Game': ")
    ta.log("====================================================")

proc patch_game(ta: TextArea): void =
  if not is_eqgame_ok():
    ta.log("ERROR: Refusing to patch files - your eqgame.exe is incorrect.")
    ta.log("Please try 'Check Game Files' for help, or correct your directory.")
    return

  ta.log("Updating the game files...")
  unzip_file_1(ta, fetch_file_1(ta))
  ta.log("Game is up to date!")

proc run_game(ta: TextArea): void =
  const gameFile = "./eqgame.exe"

  if not fileExists(gameFile):
    ta.log(&"Missing game file: {gameFile}")
    return

  if not is_eqgame_ok() or not is_eqdll_ok():
    ta.log("Please try 'Check Game Files' for help, or correct your directory.")
    return

  when defined windows:
    let result = execProcess(gameFile, args=[], options={poUsePath})
    ta.log(result)
  else:
    let result = execProcess("wine", args=[gameFile], options={poUsePath})
    ta.log(result)

when isMainModule:
  app.init()
  let patcherDir = os.getCurrentDir()
  let gameDirFile = &"{patcherDir}/gamedir.txt"
  var gameDir = ""

  if fileExists(gameDirFile):
    gameDir = readFile(gameDirFile)

    if dirExists(gameDir):
      os.setCurrentDir(gameDir)
    else:
      echo "Invalid gamedir.txt - ignoring."

  let window = newWindow("Quarm Patcher")
  window.width = 600.scaleToDpi
  window.height = 400.scaleToDpi
  # window.iconPath = "EverQuest.ico"

  let containerOuter = newLayoutContainer(Layout_Vertical)
  let container1 = newLayoutContainer(Layout_Horizontal)
  let container2 = newLayoutContainer(Layout_Horizontal)
  window.add(containerOuter)
  containerOuter.add(container1)
  containerOuter.add(container2)

  let buttonCheck = newButton("Check Game Files")
  container1.add(buttonCheck)

  let buttonPatch = newButton("Patch Game")
  container1.add(buttonPatch)

  let buttonLaunch = newButton("Launch Game")
  container1.add(buttonLaunch)

  var buttonDir = newButton(&"Game Dir: [{gameDir}]")
  container2.add(buttonDir)

  let buttonClear = newButton("Clear Text")
  container2.add(buttonClear)

  let buttonExit = newButton("Exit")
  container2.add(buttonExit)

  let textArea = newTextArea()
  textArea.editable = false
  containerOuter.add(textArea)

  buttonCheck.onClick = proc(event: ClickEvent) = check_game(textArea)
  buttonPatch.onClick = proc(event: ClickEvent) = patch_game(textArea)
  buttonLaunch.onClick = proc(event: ClickEvent) = run_game(textArea)
  buttonExit.onClick = proc(event: ClickEvent) = app.quit()

  textArea.log("This patcher is BETA (much like Quarm :)) - please check GitHub for new releases (at least until I add a self updater perhaps...).")

  buttonClear.onClick = proc(event: ClickEvent) =
    textArea.text = ""

  buttonDir.onClick = proc(event: ClickEvent) =
    var dialog = SelectDirectoryDialog()
    dialog.title = "Test Save"
    dialog.startDirectory = gameDir
    dialog.run()
    if dialog.selectedDirectory == "":
      textArea.addLine("No dir selected")
    else:
      gameDir = dialog.selectedDirectory
      textArea.log(&"Changed directory to: {gameDir}")
      os.setCurrentDir(gameDir)
      buttonDir.text = &"Game Dir: [{gameDir}])"
      writeFile(gameDirFile, gameDir)

  # window.alert("This is a simple message box.")
  window.show()
  app.run()
