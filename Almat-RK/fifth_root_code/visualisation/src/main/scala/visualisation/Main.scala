package visualisation

import java.awt.Color
import java.io.{DataInputStream, FileInputStream}

import de.sciss.file._
import de.sciss.intensitypalette.IntensityPalette
import de.sciss.kollflitz.Vec
import de.sciss.numbers.Implicits._
import de.sciss.pdflitz.Generate

import scala.swing.{Component, Dimension, Graphics2D, MainFrame, Swing}

object Main {
  case class Config(binIn: File, elemWidth: Int = 1 /*6*/, elemHeight: Int = 2 /*6*/, voiceSpacing: Int = 4 /*18*/,
                   scoreSpacing: Int = 8 /*18*/, hPad: Int = 4, vPad: Int = 4, pdfOut: File,
                    sliceFrom: Int = 60, sliceUntil: Int = 72, show: Boolean = false)

  def main(args: Array[String]): Unit = {
    run(Config(binIn = file("../rk-scores.bin"), pdfOut = file("../rk-scores.pdf")))
  }

  def run(c: Config): Unit = {
    val fin = new DataInputStream(new FileInputStream(c.binIn))
    val scores0: Vec[Vec[Vec[Int]]] = try {
      val numScores = fin.readInt()
      Vec.fill(numScores) {
        val numVoices = fin.readInt()
        Vec.fill(numVoices) {
          val numElem = fin.readInt()
          Vec.fill(numElem)(fin.readInt())
        }
      }
    } finally {
      fin.close()
    }

    val scores = scores0 // .distinct
    val allData: Vec[Int] = scores.flatMap(_.flatten)
    val maxElem = allData.max
    val maxVoices = scores.map(_.size).max
    println(s"num scores ${scores.size}; max voices $maxVoices; num items ${allData.size}; min item ${allData.min}; max item $maxElem") // min -1, max 12
    val slice = scores.slice(c.sliceFrom, c.sliceUntil)
    draw(c, slice)
  }

  def draw(c: Config, slice0: Vec[Vec[Vec[Int]]]): Unit = {
    val slice             = slice0.map { score => score.filter(_.exists(_ >= 0)) }
    val numScores         = slice.size
    val voiceInnerHeight  = c.elemHeight * 13
    val voiceHeight       = voiceInnerHeight + c.voiceSpacing
    val voiceLengths      = slice.map(_.map(_.size).max)
    val voiceLengthSum    = voiceLengths.sum
    val maxVoices         = slice.map(_.size).max

    println(s"Slice: maxVoices $maxVoices")

    val drawWidth   = voiceLengthSum * c.elemWidth + (numScores - 1) * c.scoreSpacing + c.hPad * 2
    val drawHeight  = maxVoices * voiceHeight - c.voiceSpacing + c.vPad * 2

    val drawFun: Graphics2D => Unit = { g =>
      var sx = c.hPad
      slice.zipWithIndex.foreach { case (score, _ /*si*/) =>
        var y = (maxVoices - score.size) * voiceHeight + c.vPad
        var maxX = 0
        val voiceLen = score.map(_.size).max
        score.zipWithIndex.foreach { case (voice, _ /*vi*/) =>
          var x = sx
          val yOff = y + voiceInnerHeight
          g.setColor(new Color(0xFCFCFC))
          g.fillRect(sx, y, voiceLen * c.elemWidth, voiceInnerHeight)
          g.setColor(new Color(0xF6F6F6))
          val vLeft   = voice.segmentLength(_ < 0)
          val vRight  = voice.reverse.segmentLength(_ < 0)
          g.fillRect(sx + vLeft * c.elemWidth, y, voiceLen - (vLeft + vRight) * c.elemWidth, voiceInnerHeight)
          voice.zipWithIndex.foreach { case (elem, _ /*ei*/) =>
            if (elem >= 0) {
              val v = elem.linLin(0, 12, 0.3f, 0.8f)
              g.setColor(new Color(IntensityPalette.apply(v)))
              g.fillRect(x, yOff - (elem + 1) * c.elemHeight, c.elemWidth, c.elemHeight)
            }
            x += c.elemWidth
          }
          y += voiceHeight
          maxX = math.max(maxX, x)
        }
        sx = maxX + c.scoreSpacing
      }
    }

    if (c.pdfOut.path.nonEmpty) {
      val s: Generate.Source = new Generate.Source {
        def render(g: Graphics2D): Unit = drawFun(g)
        val size: Dimension = new Dimension(drawWidth, drawHeight)
        val preferredSize: Dimension = size
      }

      Generate(c.pdfOut, s, overwrite = true)
    }

    if (c.show) Swing.onEDT {
      new MainFrame {
        title = "Vis"

        contents = new Component {
          preferredSize = new Dimension(drawWidth, drawHeight)
          opaque        = true

          override protected def paintComponent(g: Graphics2D): Unit = {
            super.paintComponent(g)

//            val atOrig = g.getTransform
            g.setColor(Color.white)
            g.fillRect(0, 0, drawWidth, drawHeight)

          }
        }

        pack().centerOnScreen()
        open()
      }
    }
  }
}
