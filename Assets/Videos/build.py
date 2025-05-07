import subprocess
import os


def get_starting_silence_end(file):
    proc = subprocess.run([
        "ffmpeg", "-i", file, "-af", "silencedetect=n=-50dB:d=2", "-f", "null", "i"
    ], capture_output=True)

    silence_log = proc.stderr.decode()
    for line in silence_log.split("\n"):
        if line.startswith("[silencedetect @ ") and "silence_end" in line:
            _, _, after = line.partition("silence_end: ")
            silence_end, _, _ = after.partition(" | ")
            return silence_end
    


def remove_loading_screen(src, dest):
    silence_end = get_starting_silence_end(src)
    subprocess.run(["ffmpeg", "-ss", silence_end, "-i", src, "-c", "copy", dest])


def trim_video(src, start, end, dest):
    subprocess.run(["ffmpeg", "-ss", str(start), "-to", str(end), "-i", src, "-c", "copy", dest])


def concat_videos(vids, dest):
    VIDS_PATH = "sources.txt"
    with open(VIDS_PATH, "w") as file:
        file.write("\n".join(f"file '{vid}'" for vid in vids))
    subprocess.run(["ffmpeg", "-f", "concat", "-i", VIDS_PATH, "-c", "copy", dest])
    os.remove(VIDS_PATH)


remove_loading_screen("v1.avi", "p1.avi")
# remove_loading_screen("v2.avi", "p2.avi")
# remove_loading_screen("v3.avi", "p3.avi")

trim_video("p1.avi", 0, 16.6, "s1.avi")
trim_video("p2.avi", 16.6, 18.1, "s2.avi")
trim_video("p3.avi", 18.1, 19.1, "s3.avi")
trim_video("p1.avi", 19.1, 21.5, "s4.avi")

concat_videos(["s1.avi", "s2.avi", "s3.avi", "s4.avi"], "result.avi")
