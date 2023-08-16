# nimble install zip
# nimble install nigui
import httpClient, nigui, osproc, zip/zipfiles

proc fetch_file_1(): string =
  var url = "https://cdn.discordapp.com/attachments/1135981619858128998/1137492344162234368/projectquarm_08_05_2023.zip"
  var client = newHttpClient()
  var zipContent = client.getContent(url)
  var filename = "quarm_latest.zip"
  writeFile(fileName, zipContent)

  return fileName

proc unzip_file_1(filename: string): void =
  var z: ZipArchive

  if not z.open(filename):
    echo "Opening zip failed"
  else:
    # extracts all files from archive z to the destination directory.
    z.extractAll(".")

proc patch_game(): void =
  echo "Updating the game files..."
  unzip_file_1(fetch_file_1())
  echo "Game is up to date!"

proc run_game(): void =
  let result = execProcess("./eqgame.exe", args=[], options={poUsePath})
  echo result

when isMainModule:
  app.init()
  var window = newWindow("NiGui Example")
  window.width = 600.scaleToDpi
  window.height = 400.scaleToDpi
  # window.iconPath = "EverQuest.ico"

  var container = newLayoutContainer(Layout_Vertical)
  window.add(container)

  var buttonPatch = newButton("Patch Game")
  container.add(buttonPatch)

  var buttonRun = newButton("Run Game")
  container.add(buttonRun)

  var buttonExit = newButton("Exit")
  container.add(buttonExit)

  var textArea = newTextArea()
  container.add(textArea)

  buttonPatch.onClick = proc(event: ClickEvent) = patch_game()
  buttonRun.onClick = proc(event: ClickEvent) = run_game()
  buttonExit.onClick = proc(event: ClickEvent) = app.quit()

  textArea.addLine("Button 1 clicked, message box opened.")
  window.alert("This is a simple message box.")
  textArea.addLine("Message box closed.")
  window.show()
  app.run()
