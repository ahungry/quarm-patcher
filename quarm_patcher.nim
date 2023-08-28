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
  var content: string = ""

  if fileExists("./eqgame.exe"):
    content = readFile("./eqgame.exe")

  if "b86646f1a48990a9355644b6e146e70c" == getMD5(content):
    ta.log("./eqgame.exe is the expected version")
  else:
    ta.log("====================================================")
    ta.log("./eqgame.exe is NOT the expected version - visit: ")
    ta.log("")
    ta.log("https://wiki.takp.info/index.php/Getting_Started_on_Windows#Obtaining_and_Running_the_Client")
    ta.log("")
    ta.log("to download the proper game files (use link #1)")
    ta.log("====================================================")

proc patch_game(ta: TextArea): void =
  ta.log("Updating the game files...")
  unzip_file_1(ta, fetch_file_1(ta))
  ta.log("Game is up to date!")

proc run_game(ta: TextArea): void =
  const gameFile = "./eqgame.exe"

  if not fileExists(gameFile):
    ta.log(&"Missing game file: {gameFile}")
    return

  let result = execProcess(gameFile, args=[], options={poUsePath})
  ta.log(result)

when isMainModule:
  app.init()
  let window = newWindow("Quarm Patcher")
  window.width = 600.scaleToDpi
  window.height = 400.scaleToDpi
  # window.iconPath = "EverQuest.ico"

  let container = newLayoutContainer(Layout_Vertical)
  window.add(container)

  let buttonCheck = newButton("Check Game Files")
  container.add(buttonCheck)

  let buttonPatch = newButton("Patch Game")
  container.add(buttonPatch)

  let buttonRun = newButton("Run Game")
  container.add(buttonRun)

  let buttonExit = newButton("Exit")
  container.add(buttonExit)

  let textArea = newTextArea()
  textArea.editable = false
  container.add(textArea)

  buttonCheck.onClick = proc(event: ClickEvent) = check_game(textArea)
  buttonPatch.onClick = proc(event: ClickEvent) = patch_game(textArea)
  buttonRun.onClick = proc(event: ClickEvent) = run_game(textArea)
  buttonExit.onClick = proc(event: ClickEvent) = app.quit()

  # window.alert("This is a simple message box.")
  window.show()
  app.run()
