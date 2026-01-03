package com.nativetestharness

import android.app.Application
import io.michaelfay.fabrichtmltext.FabricHTMLTextView
import io.michaelfay.fabrichtmltext.FabricHTMLTextViewManager
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

/**
 * Tests for FabricHTMLTextViewManager - the Fabric view manager.
 *
 * These tests verify the React Native integration layer works correctly
 * when the library is included in a React Native app.
 *
 * Note: The standalone tests in android/src/test already cover FabricHTMLTextView
 * behavior. These tests focus on verifying the manager is properly configured
 * and the props work through the manager interface.
 */
@RunWith(RobolectricTestRunner::class)
@Config(manifest = Config.NONE, application = Application::class)
class FabricHTMLTextViewManagerTest {

    private lateinit var manager: FabricHTMLTextViewManager
    private lateinit var view: FabricHTMLTextView

    @Before
    fun setUp() {
        manager = FabricHTMLTextViewManager()
        // Create view directly for testing props
        view = FabricHTMLTextView(RuntimeEnvironment.getApplication())
    }

    // ========== Manager Configuration ==========

    @Test
    fun `manager has correct name`() {
        assertEquals("FabricHTMLTextView", manager.name)
    }

    // ========== Prop Setting Through Manager ==========

    @Test
    fun `setHtml updates view content`() {
        manager.setHtml(view, "<p>Hello World</p>")

        assertEquals("Hello World", view.text.toString().trim())
    }

    @Test
    fun `setHtml with null clears content`() {
        manager.setHtml(view, "<p>Initial</p>")
        manager.setHtml(view, null)

        assertEquals("", view.text.toString())
    }

    @Test
    fun `setHtml with empty string clears content`() {
        manager.setHtml(view, "<p>Initial</p>")
        manager.setHtml(view, "")

        assertEquals("", view.text.toString())
    }

    // ========== HTML Rendering Through Manager ==========

    @Test
    fun `manager renders bold text correctly`() {
        manager.setHtml(view, "<strong>Bold</strong>")

        assertEquals("Bold", view.text.toString())
    }

    @Test
    fun `manager renders italic text correctly`() {
        manager.setHtml(view, "<em>Italic</em>")

        assertEquals("Italic", view.text.toString())
    }

    @Test
    fun `manager sanitizes script tags`() {
        manager.setHtml(view, "<p>Safe<script>alert(1)</script></p>")

        val text = view.text.toString()
        assertTrue("Should contain Safe", text.contains("Safe"))
        assertFalse("Should not contain script content", text.contains("alert"))
    }
}
