const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'uts_flutter',
});

db.connect((err) => {
  if (err) {
    console.error('MySQL failed: ' + err.message);
  } else {
    console.log('MySQL Connected');
  }
});

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/'); // Save image to 'uploads/'
  },
  filename: (req, file, cb) => {
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

//get
app.get('/users', (req, res) => {
  const query = 'SELECT * FROM user';
  db.query(query, (err, results) => {
    if (err) {
      res.status(500).send(err);
    } else {
      res.json({ data: results });
    }
  });
});

//post
app.post('/users', upload.single('photo'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: 'No file uploaded' });
  }

  const { name, email, username, password, handphone } = req.body;
  const photo = req.file.filename;

  // Add query to check username in database
  const checkUsernameQuery = 'SELECT id FROM user WHERE username = ?';
  db.query(checkUsernameQuery, [username], (checkUsernameErr, checkUsernameResults) => {
    if (checkUsernameErr) {
      return res.status(500).json({ message: 'Database error' });
    }

    if (checkUsernameResults.length > 0) {
      return res.status(400).json({ message: 'Username already exists' });
    } else {
      // If username is empty
      const insertUserQuery = 'INSERT INTO user (name, email, username, password, photo, handphone) VALUES (?, ?, ?, ?, ?, ?)';
      db.query(insertUserQuery, [name, email, username, password, photo, handphone], (insertErr, insertResult) => {
        if (insertErr) {
          return res.status(500).json({ message: 'Failed to insert user data' });
        } else {
          return res.status(200).json({ message: 'New user added', id: insertResult.insertId });
        }
      });
    }
  });
});


//put
// app.put('/users/:id', upload.single('photo'), (req, res) => {
//   const userId = req.params.id;
//   const { name, email, username, password, handphone } = req.body;
//   const photo = req.file ? req.file.filename : null;
//   const query = 'UPDATE user SET name=?, email=?, username=?, password=?, photo=?, handphone=? WHERE id=?';
//   db.query(query, [name, email, username, password, photo, handphone, userId], (err, result) => {
//     if (err) {
//       res.status(500).send(err);
//     } else {
//       res.json({ message: 'New user added', id: userId });
//     }
//   });
// });

app.put('/users/:id', upload.single('photo'), (req, res) => {
  const userId = req.params.id;
  const { name, email, username, password, handphone } = req.body;

  if (req.file) {
    const photo = req.file.filename;
    const query = 'UPDATE user SET name=?, email=?, username=?, password=?, photo=?, handphone=? WHERE id=?';
    db.query(query, [name, email, username, password, photo, handphone, userId], (err, result) => {
      if (err) {
        res.status(500).send(err);
      } else {
        res.json({ message: 'User data has been updated', id: userId });
      }
    });
  } else {
    // use photo before
    const query = 'UPDATE user SET name=?, email=?, username=?, password=?, handphone=? WHERE id=?';
    db.query(query, [name, email, username, password, handphone, userId], (err, result) => {
      if (err) {
        res.status(500).send(err);
      } else {
        res.json({ message: 'User data has been updated', id: userId });
      }
    });
  }
});


//end point show photo
app.use('/uploads', express.static('uploads'));

//del
app.delete('/users/:id', (req, res) => {
  const userId = req.params.id;
  const query = 'DELETE FROM user WHERE id=?';
  db.query(query, [userId], (err, result) => {
    if (err) {
      res.status(500).send(err);
    } else {
      res.json({ message: 'User has been deleted', id: userId });
    }
  });
});

//login
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const query = 'SELECT * FROM user WHERE username = ? AND password = ?';
  db.query(query, [username, password], (err, results) => {
    if (err) {
      res.status(500).send(err);
    } else {
      if (results.length > 0) {
        res.status(200).json({ data: { message: 'Login success' } });
      } else {
        res.status(401).json({ message: 'Login failed' });
      }
    }
  });
});

//reset pass
app.put('/users/resetpass/:id', (req, res) => {
  const userId = req.params.id;
  const { password } = req.body;

  if (password === undefined || password === '') {
    return res.status(400).json({ message: 'The password cannot be empty' });
  }

  const query = 'UPDATE user SET password=? WHERE id=?';
  db.query(query, [password, userId], (err, result) => {
    if (err) {
      res.status(500).send(err);
    } else {
      res.json({ message: 'User password has been updated', id: userId });
    }
  });
});

//get username
app.get('/users/:username', (req, res) => {
  const username = req.params.username;
  const query = 'SELECT * FROM user WHERE username = ?';
  db.query(query, [username], (err, results) => {
    if (err) {
      res.status(500).send(err);
    } else {
      if (results.length > 0) {
        res.json({ data: results[0] });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    }
  });
});

//get photo
app.get('/images/:filename', (req, res) => {
  const filename = req.params.filename;
  const imagePath = path.join(__dirname, 'uploads', filename);

  fs.readFile(imagePath, (err, data) => {
    if (err) {

      res.status(404).send('Image not found');
    } else {
      // send response
      res.writeHead(200, { 'Content-Type': 'image/jpeg' });
      res.end(data);
    }
  });
});


app.listen(3000, () => {
  console.log('The server runs on port 3000');
});
