/** Interface to handle the button clicks */
public interface OnClickListener {
  /** Called when the button is clicked. */
  public void onClick();
}

/** Represents a clickable button in the program */
public class Button implements OnClickListener {
  
  /** The x coordinate of the top left coorner of the button */
  private final float x;
  /** The y coordinate of the top left coorner of the button */
  private final float y;
  /** The width of the button */
  private final float width;
  /** The height of the button */
  private final float height;
  /** The listener which will called when the button is clicked */
  private final OnClickListener clickListener;
  
  public Button(float x, float y, float width, float height, OnClickListener clickListener) {
    //println(x + ", " + y + ", " + width + ", " + height);
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.clickListener = clickListener;
  }
  
  /**
   * Check if the given point is inside the button or not.
   *
   * @param clickX the x coordinate of the point to check.
   * @param clickY the y coordinate of the point to check.
   * @return true if the point is inside the button
   */
  public boolean isInside(float clickX, float clickY) {
    return clickX >= x && clickX <= x + width && clickY >= y && clickY <= y + height;
  }
  
  void onClick() {
    clickListener.onClick();
  }
}
