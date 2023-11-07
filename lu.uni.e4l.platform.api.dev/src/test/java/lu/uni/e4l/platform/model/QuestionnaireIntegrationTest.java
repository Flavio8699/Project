package lu.uni.e4l.platform.model;

import lu.uni.e4l.platform.model.Question;
import lu.uni.e4l.platform.model.Questionnaire;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class QuestionnaireIntegrationTest {

    private Questionnaire questionnaire;

    @Before
    public void setUp() {
        // Create a list of questions for the questionnaire
        List<Question> questions = new ArrayList<>();
        questions.add(createQuestion(1, "Question 1"));
        questions.add(createQuestion(2, "Question 2"));

        // Create the questionnaire with a name and the list of questions
        questionnaire = new Questionnaire("Test Questionnaire", questions);
    }

    @Test
    public void testGetQuestion() {
        // Create a mock Question object with ID 2
        Question mockQuestion = createQuestion(2, "Question 2");

        // Use the getQuestion method to find a question with ID 2
        // It should return the mockQuestion we created
        assertEquals(mockQuestion, questionnaire.getQuestion(2).orElse(null));
    }

    private Question createQuestion(long id, String text) {
        Question question = new Question();
        question.setId(id);
        question.setName(text);
        return question;
    }
}
