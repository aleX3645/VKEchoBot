import com.vk.api.sdk.objects.messages.Message;

public class Messenger implements Runnable{

    private Message message;
    private VKManager manager = new VKManager();

    public Messenger(Message message){
        this.message = message;
    }

    @Override
    public void run() {
        manager.sendMessage(message.getBody(), message.getUserId());
    }
}
