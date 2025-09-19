import os
from datetime import datetime

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    user = db.execute("select cash from users where id = ?", session["user_id"])[0]
    cash = user["cash"]
    holdings = db.execute(
        """select symbol, SUM(shares) as total_shares from transactions where user_id = ? group by symbol having total_shares > 0""", session["user_id"])
    total_value = cash
    for holding in holdings:
        stock = lookup(holding["symbol"])
        holding["name"] = stock["name"]
        holding["price"] = stock["price"]
        holding["value"] = stock["price"] * holding["total_shares"]
        total_value += holding["value"]
    return render_template("index.html", holdings=holdings, cash=cash, total_value=total_value)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":
        symbol = request.form.get("symbol")
        shares = request.form.get("shares")
        if not symbol:
            return apology("must provide symbol")
        if not shares or not shares.isdigit() or int(shares) <= 0:
            return apology("must provide positive integer number of shares")
        shares = int(shares)
        stock = lookup(symbol)
        if not stock:
            return apology("invalid symbol")
        total_cost = stock["price"] * shares
        user = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])[0]
        if user["cash"] < total_cost:
            return apology("can't afford")
        db.execute("UPDATE users SET cash = cash - ? WHERE id = ?", total_cost, session["user_id"])
        db.execute("""INSERT INTO transactions (user_id, symbol, shares, price) VALUES (?, ?, ?, ?)""",
                   session["user_id"], stock["symbol"], shares, stock["price"])
        flash("Bought!")
        return redirect("/")
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    transactions = db.execute(
        """SELECT symbol, shares, price, timestamp FROM transactions WHERE user_id = ? ORDER BY timestamp DESC""", session["user_id"])
    return render_template("history.html", transactions=transactions)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute(
            "SELECT * FROM users WHERE username = ?", request.form.get("username")
        )

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(
            rows[0]["hash"], request.form.get("password")
        ):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    if request.method == "POST":
        symbol = request.form.get("symbol")
        if not symbol:
            return apology("must provide symbol")
        stock = lookup(symbol)
        if not stock:
            return apology("invalid symbol")
        return render_template("quoted.html", stock=stock)
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmation")
        if not username:
            return apology("must provide username")
        if not password:
            return apology("must provide password")
        if password != confirmation:
            return apology("passwords do not match")
        try:
            user_id = db.execute(
                "INSERT INTO users (username, hash) VALUES (?, ?)",
                username,
                generate_password_hash(password)
            )
        except:
            return apology("username already exists")
        session["user_id"] = user_id
        flash("Registered!")
        return redirect("/")

    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    if request.method == "POST":
        symbol = request.form.get("symbol")
        shares = request.form.get("shares")
        if not symbol:
            return apology("must provide symbol")
        if not shares or not shares.isdigit() or int(shares) <= 0:
            return apology("must provide positive integer number of shares")
        shares = int(shares)
        holdings = db.execute(
            """SELECT SUM(shares) as total_shares FROM transactions WHERE user_id = ? AND symbol = ? GROUP BY symbol""", session["user_id"], symbol)
        if not holdings or holdings[0]["total_shares"] < shares:
            return apology("not enough shares")
        stock = lookup(symbol)
        if not stock:
            return apology("invalid symbol")
        total_value = stock["price"] * shares
        db.execute("UPDATE users SET cash = cash + ? WHERE id = ?", total_value, session["user_id"])
        db.execute("""INSERT INTO transactions (user_id, symbol, shares, price) VALUES (?, ?, ?, ?)""",
                   session["user_id"], stock["symbol"], -shares, stock["price"])
        flash("Sold!")
        return redirect("/")
    else:
        stocks = db.execute(
            """SELECT symbol FROM transactions WHERE user_id = ? GROUP BY symbol HAVING SUM(shares) > 0""", session["user_id"])
        return render_template("sell.html", stocks=stocks)


@app.route("/add_cash", methods=["GET", "POST"])
@login_required
def add_cash():
    """Add cash to account"""
    if request.method == "POST":
        amount = request.form.get("amount")
        if not amount or not amount.replace('.', '', 1).isdigit() or float(amount) <= 0:
            return apology("must provide positive amount")
        amount = float(amount)
        db.execute("UPDATE users SET cash = cash + ? WHERE id = ?", amount, session["user_id"])
        flash("Cash added!")
        return redirect("/")
    else:
        return render_template("add_cash.html")
