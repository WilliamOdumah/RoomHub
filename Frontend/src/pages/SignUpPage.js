import React, {useState} from 'react';
import { useNavigate } from 'react-router-dom';
import { addUser, getUserById } from '../mockApi';

const SignUpPage = () => {
    const navigate = useNavigate();
    const [email, setEmail] = useState('');

    // Function to handle input change
    const handleEmailChange = (event) => {
        setEmail(event.target.value);  // Update state with the entered email
    };

    // Function to handle the Sign-Up process
    const handleSignUp = () => {
        if (!email) {
            alert('Please enter your email');  // Make sure user enters email
            return;
        }
        if (getUserById(email)) {
            alert('User already exists!');  // Make sure user enters email
            return;
        }
        addUser(email);
        // Navigate to the home page, with hasRoom set to false
        navigate('/home', { state: { hasRoom: false, email: email } });  // Pass email as part of the state
    };

    return (
        <div>
        <h1>Sign Up Page</h1>
        {/* Input field for email */}
        <label htmlFor="email">Email:</label>
        <input
            type="email"
            id="email"
            name="email"
            value={email}
            onChange={handleEmailChange}
            required
        />
        <button onClick={handleSignUp}>Sign Up</button>
        </div>
    );
};

export default SignUpPage;
