const mysql = require("mysql");
const express = require("express");
const mysqlConnection = require('./utils/database');
const bodyParser = require("body-parser");
const path = require('path'); 
const qbRoutes = require("./routes/qb");
const bcrypt = require('bcrypt');


const app = express();

app.use(bodyParser.json());

app.use(qbRoutes);
// Serve static files
app.use(express.static(path.join(__dirname, 'public')));
// Login route
/// Login route
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
      const query = 'SELECT * FROM Members WHERE Email = ?'; // Select user by email
      mysqlConnection.query(query, [email], async (err, results) => {
          if (err) {
              return res.status(500).send('Server error');
          }

          if (results.length === 0) {
              return res.status(401).send('Invalid credentials');
          }

          const user = results[0]; // Assuming only one user is returned
          const isMatch = await bcrypt.compare(password, user.PWD); // Compare hashed password

          if (isMatch) {
              return res.status(200).send('Login successful');
          } else {
              return res.status(401).send('Invalid credentials');
          }
      });
  } catch (error) {
      console.error('Error comparing passwords:', error);
      res.status(500).send('Error logging in. Please try again.');
  }
});

// Route to handle signup form submission
app.post('/signup', async (req, res) => {
  const { fname, lname, dob, address, phone, inputEmail, inputPassword } = req.body;

  try {
      // Hash the password using bcrypt
      const hashedPassword = await bcrypt.hash(inputPassword, 10); // 10 is the saltRounds parameter

      const sql = `INSERT INTO Members (FirstName, LastName, DOB, Address, Phone, Email, PWD) VALUES (?, ?, ?, ?, ?, ?, ?)`;
      const values = [fname, lname, dob, address, phone, inputEmail, hashedPassword]; // Use hashedPassword instead of inputPassword
      console.log(req.body);

      mysqlConnection.query(sql, values, (err, result) => {
          if (err) {
              console.error('Error executing MySQL query:', err);
              res.status(500).send('Error signing up. Please try again.');
              return;
          }
          console.log('User signed up successfully:', result);
          res.status(200).send('Signup successful');
      });
  } catch (error) {
      console.error('Error hashing password:', error);
      res.status(500).send('Error signing up. Please try again.');
  }
});

  // Route to handle home page or other pages
app.get('/home', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
  });
// app.listen(4000);

  
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });

