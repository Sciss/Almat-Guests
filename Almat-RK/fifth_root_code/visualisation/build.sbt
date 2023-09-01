lazy val baseName         = "Fifth-Root-Visualisation"
lazy val baseNameL        = baseName.toLowerCase
lazy val projectVersion   = "0.1.0-SNAPSHOT"

lazy val commonSettings = Seq(
  version             := projectVersion,
  organization        := "de.sciss",
  description         := "Visualisation of the patterns of Ron Kuivila's piece",
  scalaVersion        := "2.13.3",
  licenses            := Seq(agpl3),
  scalacOptions      ++= Seq("-deprecation", "-unchecked", "-feature", "-encoding", "utf8", "-Xlint"),
  libraryDependencies ++= Seq(
    "de.sciss"          %% "fileutil"           % "1.1.4",
    "de.sciss"          %% "numbers"            % "0.2.0",
    "de.sciss"          %% "kollflitz"          % "0.2.3",
    "de.sciss"          %% "pdflitz"            % "1.4.1",
    "de.sciss"          %  "intensitypalette"   % "1.0.2",
  )
)

lazy val agpl3 = "AGPL v3+" -> url("http://www.gnu.org/licenses/agpl-3.0.txt")

lazy val root = Project(id = baseNameL, base = file("."))
  .settings(commonSettings)
