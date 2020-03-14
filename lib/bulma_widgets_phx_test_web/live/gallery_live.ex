defmodule BulmaWidgetsPhxTestWeb.GalleryLive do

  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <h1>LiveView is awesome!</h1>
      <section class="section">
        <h1 class="title">
          Bulma
        </h1>

        <p class="subtitle">
          Modern CSS framework based on <a href="https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Basic_Concepts_of_Flexbox">Flexbox</a>
        </p>

        <div class="field">
          <div class="control">
            <input class="input" type="text" placeholder="Input">
          </div>
        </div>

        <div class="field">
          <p class="control">
            <span class="select">
              <select>
                <option>Select dropdown</option>
              </select>
            </span>
          </p>
        </div>

        <div class="buttons">
          <a class="button is-primary">Primary</a>
          <a class="button is-link">Link</a>
        </div>
      </section>

    """
  end
end
