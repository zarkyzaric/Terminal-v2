import streamlit as st
def draw(string):
    st.write(string)

st.title("Home Page 🏠", anchor="title")
st.write("Here are your all automation scripts all in one place:")

col1, col2 = st.columns(2)
with col1:
    st.write(
    """
    - Terminal
    - Hotkeys
    - Hotstrings
    """
    )

with col2:
    text_input = st.text_input(
        "Enter some text 👇",   
    )
    if text_input:
        st.write("You entered: ", text_input)
