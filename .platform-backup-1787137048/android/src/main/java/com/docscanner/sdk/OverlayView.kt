package com.docscanner.sdk

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.util.AttributeSet
import android.view.View
import androidx.annotation.ColorInt

/**
 * Custom View that draws a crop overlay rectangle
 * with customizable border color, width, and corner radius
 */
class OverlayView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeCap = Paint.Cap.ROUND
        strokeJoin = Paint.Join.ROUND
    }

    private val backgroundPaint = Paint().apply {
        color = Color.parseColor("#80000000")
        style = Paint.Style.FILL
    }

    @ColorInt
    var borderColor: Int = Color.WHITE
        set(value) {
            field = value
            paint.color = value
            invalidate()
        }

    var borderWidth: Float = 8f
        set(value) {
            field = value
            paint.strokeWidth = value
            invalidate()
        }

    var cornerRadius: Float = 24f
        set(value) {
            field = value
            invalidate()
        }

    private val overlayRect = RectF()

    init {
        context.theme.obtainStyledAttributes(
            attrs,
            R.styleable.OverlayView,
            0, 0
        ).apply {
            try {
                borderColor = getColor(R.styleable.OverlayView_overlayBorderColor, Color.WHITE)
                borderWidth = getDimension(R.styleable.OverlayView_overlayBorderWidth, 8f)
                cornerRadius = getDimension(R.styleable.OverlayView_overlayCornerRadius, 24f)
            } finally {
                recycle()
            }
        }

        paint.color = borderColor
        paint.strokeWidth = borderWidth
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

        val w = width.toFloat()
        val h = height.toFloat()

        // Draw dimmed background outside the rectangle
        canvas.drawRect(0f, 0f, w, 0f, backgroundPaint) // Top
        canvas.drawRect(0f, h, w, h, backgroundPaint) // Bottom
        canvas.drawRect(0f, 0f, 0f, h, backgroundPaint) // Left
        canvas.drawRect(w, 0f, w, h, backgroundPaint) // Right

        // Draw the crop rectangle
        overlayRect.set(
            borderWidth / 2,
            borderWidth / 2,
            w - borderWidth / 2,
            h - borderWidth / 2
        )

        canvas.drawRoundRect(overlayRect, cornerRadius, cornerRadius, paint)

        // Draw corner indicators (optional, for better UX)
        drawCornerIndicators(canvas)
    }

    private fun drawCornerIndicators(canvas: Canvas) {
        val cornerLength = 40f
        val cornerPaint = Paint(paint).apply {
            strokeWidth = borderWidth * 1.5f
        }

        val left = overlayRect.left
        val top = overlayRect.top
        val right = overlayRect.right
        val bottom = overlayRect.bottom

        // Top-left corner
        canvas.drawLine(left, top + cornerRadius, left, top + cornerRadius + cornerLength, cornerPaint)
        canvas.drawLine(left + cornerRadius, top, left + cornerRadius + cornerLength, top, cornerPaint)

        // Top-right corner
        canvas.drawLine(right, top + cornerRadius, right, top + cornerRadius + cornerLength, cornerPaint)
        canvas.drawLine(right - cornerRadius, top, right - cornerRadius - cornerLength, top, cornerPaint)

        // Bottom-left corner
        canvas.drawLine(left, bottom - cornerRadius, left, bottom - cornerRadius - cornerLength, cornerPaint)
        canvas.drawLine(left + cornerRadius, bottom, left + cornerRadius + cornerLength, bottom, cornerPaint)

        // Bottom-right corner
        canvas.drawLine(right, bottom - cornerRadius, right, bottom - cornerRadius - cornerLength, cornerPaint)
        canvas.drawLine(right - cornerRadius, bottom, right - cornerRadius - cornerLength, bottom, cornerPaint)
    }
}
