defmodule PlausibleWeb.AdminAuthControllerTest do
  use PlausibleWeb.ConnCase
  import Plausible.TestUtils

  describe "GET /" do
    test "disable landing page", %{conn: conn} do
      set_config(disable_landing_page: true)
      conn = get(conn, "/")
      assert redirected_to(conn) == "/login"
    end

    test "disable authentication", %{conn: conn} do
      set_config(disable_authentication: true)

      admin_user =
        Plausible.Auth.find_user_by(email: Application.get_env(:plausible, :admin_email))

      # goto landing page
      conn = get(conn, "/")
      assert get_session(conn, :current_user_id) == admin_user.id
      assert redirected_to(conn) == "/sites"

      # trying logging out
      conn = post(conn, "/logout")
      assert redirected_to(conn) == "/"
      conn = get(conn, "/")
      assert redirected_to(conn) == "/sites"
    end

    test "disable registration", %{conn: conn} do
      set_config(disable_registration: true)
      conn = get(conn, "/register")
      assert redirected_to(conn) == "/login"
    end
  end

  def reset_config do
    [disable_landing_page: false, disable_authentication: false, disable_registration: false]
    |> set_config()
  end

  def set_config(config) do
    updated_config =
      Keyword.merge(
        [disable_landing_page: false, disable_authentication: false, disable_registration: false],
        config
      )

    Application.put_env(
      :plausible,
      :selfhost,
      updated_config
    )
  end
end
