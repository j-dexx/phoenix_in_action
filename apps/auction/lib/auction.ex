defmodule Auction do
  alias Auction.{Repo, Item, User, Password}

  @repo Repo

  def list_items do
    @repo.all(Item)
  end

  def new_item, do: Item.changeset(%Item{})

  def edit_item(id) do
    get_item(id)
    |> Item.changeset()
  end

  def get_item(id), do: @repo.get!(Item, id)

  def get_item_by(attrs) do
    @repo.get_by(Item, attrs)
  end

  def insert_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> @repo.insert()
  end

  def update_item(%Auction.Item{} = item, updates) do
    item
    |> Item.changeset(updates)
    |> @repo.update()
  end

  def delete_item(%Auction.Item{} = item), do: @repo.delete(item)

  def get_user(id), do: @repo.get!(User, id)

  def new_user, do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  def edit_user(id) do
    get_user(id)
    |> User.changeset()
  end

  def update_user(%Auction.User{} = user, updates) do
    user
    |> User.changeset(updates)
    |> @repo.update()
  end

  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
         true <- Password.verify_with_hash(password, user.hashed_password) do
      user
    else
      _ -> Password.dummy_verify()
    end
  end
end
